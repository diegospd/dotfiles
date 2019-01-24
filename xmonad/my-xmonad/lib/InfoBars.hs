module InfoBars (logBar, infoBars, conkyIcon) where

import Data.Maybe
import Data.List
import Control.Monad.Reader

-- screenConf = conf_1366
screenConf = conf_1280_1920
-- screenConf = conf_1280

conf_1366 :: Screens
conf_1366 = SConf {
    left = Just $ Screen 1366 768 [
        bar_log,
        -- bar_wifi,
        bar_clock,
        bar_date
    ],
    middle = Nothing,
    right = Nothing,
    logBarScreen = SLeft
}

conf_1280 :: Screens
conf_1280 = SConf {
    left = Just $ Screen 1280 1024 [
        bar_log,
        bar_clock,
        bar_date
    ],
    middle = Nothing,
    right = Nothing,
    logBarScreen = SMiddle
}



conf_1280_1920 :: Screens
conf_1280_1920 = SConf {
    left = Just $ Screen 1280 1024 [
        bar_wifi,
        bar_ethernet,
        bar_cpu,
        bar_fs
    ],
    middle = Just $ Screen 1920 1080 [
        bar_log,
        bar_clock,
        bar_date,
        bar_arch,
        bar_sound
    ],
    right = Nothing,
    logBarScreen = SMiddle
}


------------------------------------------------------------------


data Screen  = Screen {
    s_width  :: Int,
    s_height :: Int,
    bars     :: [InfoBar]
} deriving (Eq, Show, Ord)



data Screens     = SConf {
    left         :: Maybe Screen,
    middle       :: Maybe Screen,
    right        :: Maybe Screen,
    logBarScreen :: ScreenLabel
}

data ScreenLabel = SLeft
                 | SMiddle
                 | SRight deriving (Eq, Show, Ord)


data InfoBar = Conky {
                 conky       :: String,
                 conky_width :: Int,
                 conky_align :: String   --  c, l, r
               }
             | LogBar {
                 log_align :: String
             } deriving (Eq, Show, Ord)


align :: InfoBar -> String
align x@Conky{} = conky_align x
align x@LogBar{} = log_align x


bar_log      = LogBar "l"
bar_wifi     = Conky "wifi"     210 "c"
bar_ethernet = Conky "ethernet" 150 "c"
bar_cpu      = Conky "cpu"      260 "c"
bar_fs       = Conky "fs"       400 "r"
bar_clock    = Conky "clock"    75  "c"
bar_date     = Conky "date"     250 "c"
bar_arch     = Conky "arch"     140 "c"
bar_sound    = Conky "sound"    85  "c"


----------------------------------------------

get_screens :: Screens -> [Screen]
get_screens conf = catMaybes $ [left, middle, right] <*> [conf]

get_screens' :: Screens -> [(Screen, ScreenLabel)]
get_screens' conf = mapFst fromJust <$> filter (\(m,_) -> isJust m) screens'
    where screens' = zip  ([left, middle, right] <*> [conf])  [SLeft, SMiddle, SRight]



logbar_width :: Screens -> Int
logbar_width conf = total - sum (conky_width <$> bars)
  where bars  = filter (not . isLog) $ logbar_set conf
        total = s_width $ logbar_screen conf


get_bars :: Screens -> [[InfoBar]]
get_bars conf = bars <$> get_screens conf

logbar_screen :: Screens -> Screen
logbar_screen conf = fromJust $ case logBarScreen conf of
    SLeft   -> left conf
    SMiddle -> middle conf
    SRight  -> right conf

is_logbar_screen :: Screen -> Bool
is_logbar_screen screen = any isLog $ bars screen

logbar_set :: Screens -> [InfoBar]
logbar_set = bars . logbar_screen


logbar_offset :: Screens -> Int
logbar_offset conf = sum $ conky_width <$> takeWhile (not . isLog) bars
    where bars = logbar_set conf

isLog :: InfoBar -> Bool
isLog LogBar{} = True
isLog _        = False

screen_offset :: Screens -> ScreenLabel -> Int
screen_offset _ SLeft      = 0
screen_offset conf SMiddle = maybe 0 s_width (left conf)
screen_offset conf SRight  = maybe 0 s_width (middle conf) + screen_offset conf SMiddle

logBar' :: Screens -> BarCommand
logBar' conf = mkDzen' offset (logbar_width conf) "l"
  where offset = logbar_offset conf + screen_offset conf (logBarScreen conf)

logBar :: BarCommand
logBar = logBar' screenConf

background = "#FFFFFF"
foreground = "#1B1D1E"
font = last  [ "clean"
             
             , "zeyada"
             , "vast shadow"
             , "macondo"
             , "aclonica"
             , "vt323"
             , "warnes"
             
             , "voltaire"
             , "wallpoet"
             , "text me one"
              ]

-------------------------------------------------
type BarCommand = String


infoBars :: [BarCommand]
infoBars = spawnBars screenConf

with_offset :: Screens -> [(Screen, Int)]
with_offset conf = (\(screen,label) -> (screen, extra screen + screen_offset conf label)) <$> screens
  where screens      = get_screens' conf
        extra screen = if any isLog (bars screen) then logbar_width conf else 0

spawnBars :: Screens -> [BarCommand]
spawnBars conf = spawnBars' `concatMap` with_offset conf 


spawnBars' :: (Screen, Int) -> [BarCommand]
spawnBars' (screen, offset) =  spawnBar <$> options
    where conkys   = filter (not . isLog) $ bars screen
          widths'  = conky_width <$>  conkys
          extra    = extra_space screen
          widths   = (extra +) <$> widths'
          offsets  = [ offset + sum (take n widths) | n <- [0..] ]
          aligns   = align <$> bars screen 
          options' = zip4 conkys widths offsets aligns
          options  = mapFst4 conky <$> options'

extra_space :: Screen -> Int
extra_space screen
    | is_logbar_screen screen = 0
    | otherwise = div (s_width screen - (sum $ conky_width <$> bars screen))  (length $ bars screen)



spawnBar :: (String, Int, Int, String) -> BarCommand
spawnBar (conky, width, offset, align) = cmd ++ conky ++ " | " ++ dzen
    where cmd  = "conky -c ~/.xmonad/conky/"
          dzen = mkDzen' offset width align


spawnAll :: Int
         -- ^ Horizontal offset in pixels
         -> Int
         -- ^ Length of screen in pixels 
         -> [(String, Int)]
         -- ^ conky filename, minimum length
         -> [BarCommand]
         -- ^ the command needed to spawn the (dzen2 + conky) bar
spawnAll off len bars = spawnBar <$> bars''
    where bars'  = spreadBars len bars
          bars'' = snd $ mapAccumL (\x (s, l) -> (x + l, (s, l, x, "c") )) off bars'

-- | Adds spaces among bars given the length of the target screen
spreadBars :: Int -> [(String, Int)] -> [(String, Int)]
spreadBars _ [] = []
spreadBars len bars = bars''
  where needed  = sum $ snd <$> bars
        space   = (len - needed) `div` length bars
        luckies = mod space (length bars)
        bars'   = mapSnd (+ space) <$> bars
        bars''  = (mapSnd (+ 1) <$> take luckies bars') ++ drop luckies bars' 




-- | Applies presets
mkDzen' :: Int -> Int -> String -> String
mkDzen' x w ta = mkDzen x 0 w 24 ta foreground background font

-- | Builds the dzen2 command to spawn a bar
mkDzen :: Int 
       -- ^ posición horizontal de la pantalla donde empieza la barra
       -> Int 
       -- ^ posición vertical de la pantalla donde empieza; 0 para la parte de arriba
       -> Int
       -- ^ el largo de la barra en pixeles
       -> Int
       -- ^ la altura de la barra en pixeles
       -> String
       -- ^ Alineacion c-centrado, l-left, r-right 
       -> String
       -- ^ color hexadecimal para el foreground
       -> String
       -- ^ color hexadecimal para el background
       -> String
       --  ^ fuente a usar
       -> String
mkDzen x' y' w' h' ta' bg' fg' fn' = unwords [
    "dzen2 -dock"
    , "-x",  quote  x'
    , "-y" , quote  y'
    , "-w" , quote  w'
    , "-h" , quote  h'
    , "-ta", quote' ta'
    , "-bg", quote' bg'
    , "-fg", quote' fg'
    , "-fn", quote' fn' 
    ]
  where
  quote = quote' . show
  quote' x = concat ["'", x, "'"]

conkyIcon :: String -> String
conkyIcon icon = "^i(" ++ bitmapsDir ++ "/" ++ icon ++ ")"
  -- si uso $HOME o ~ no funciona los iconos del logBar
  where bitmapsDir = "/home/diego/.xmonad/dzen2/"


mapSnd   f (x,y)     = (x,f y)
mapFst   f (x,y)     = (f x, y)
mapFst4  f (a,b,c,d) = (f a, b, c, d)
uncurry4 f (a,b,c,d) = f a b c d
