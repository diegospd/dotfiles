module InfoBars (logBar, infoBars, conkyIcon) where

import Data.Maybe
import Data.List
import Control.Monad.Reader


screenConf :: Screens
screenConf = SConf {
    left = Nothing,
    right = Nothing,
    middle = Just $ Screen 1920 1080 [
        bar_log,
        bar_clock,
        bar_date
    ],
    logBarScreen = SMiddle
}

-- screenConf :: Screens
-- screenConf = SConf {
--     left = Just $ Screen 1280 1024 [
--         bar_wifi,
--         bar_ethernet,
--         bar_cpu,
--         bar_fs
--     ],
--     middle = Just $ Screen 1920 1080 [
--         bar_log,
--         bar_clock,
--         bar_date,
--         bar_arch,
--         bar_sound
--     ],
--     right = Nothing,
--     logBarScreen = SMiddle
-- }


------------------------------------------------------------------


data Screen = Screen {
    s_width :: Int,
    s_height :: Int,
    bars :: [InfoBar]
} deriving (Eq, Show, Ord)



data Screens = SConf {
    left :: Maybe Screen,
    middle :: Maybe Screen,
    right :: Maybe Screen,
    logBarScreen :: ScreenLabel
}

data ScreenLabel = SLeft
                 | SMiddle
                 | SRight deriving (Eq, Show, Ord)



data InfoBar = Conky {
                 conky :: String,
                 conky_width :: Int,
                 conky_align :: String   --  c, l, r
               }
             | LogBar {
                 log_width :: Int,
                 log_align :: String
             } deriving (Eq, Show, Ord)

width :: InfoBar -> Int
width x@Conky{} = conky_width x
width x@LogBar{} = log_width x

align :: InfoBar -> String
align x@Conky{} = conky_align x
align x@LogBar{} = log_align x


bar_wifi = Conky "wifi" 300 "c"
bar_ethernet = Conky "ethernet" 300 "c"
bar_cpu = Conky "cpu" 260 "c"
bar_fs = Conky "fs" 400 "c"
bar_clock = Conky "clock" 280 "r"
bar_date = Conky "date" 240 "c"
bar_arch = Conky "arch" 120 "c"
bar_sound = Conky "sound" 80 "c"
bar_log = LogBar 1400 "c"

to_conky :: InfoBar -> Maybe InfoBar
to_conky x@Conky{} = Just x
to_conky _ = Nothing



----------------------------------------------
logbar_width :: Screens -> Int
logbar_width conf = log_width . head $ filter isLog (logbar_set conf)

get_screens :: Screens -> [Screen]
get_screens conf = catMaybes $ [left, middle, right] <*> [conf]

get_screens' :: Screens -> [(Screen, ScreenLabel)]
get_screens' conf = mapFst fromJust <$> filter (\(m,_) -> isJust m) screens'
    where screens' = zip  ([left, middle, right] <*> [conf])  [SLeft, SMiddle, SRight]


get_bars :: Screens -> [[InfoBar]]
get_bars conf = bars <$> get_screens conf

logbar_set :: Screens -> [InfoBar]
logbar_set conf = maybe [] bars $ case logBarScreen conf of
                                   SLeft -> left conf
                                   SMiddle -> middle conf
                                   SRight -> right conf


logbar_offset :: Screens -> Int
logbar_offset conf = sum $ conky_width <$> takeWhile (not . isLog) bars
    where bars = logbar_set conf

isLog :: InfoBar -> Bool
isLog LogBar{} = True
isLog _ = False

screen_offset :: Screens -> ScreenLabel -> Int
screen_offset _ SLeft = 0
screen_offset conf SMiddle = maybe 0 s_width (left conf)
screen_offset conf SRight = maybe 0 s_width (middle conf) + screen_offset conf SMiddle

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


infoBars = spawnBars screenConf
-- infoBars :: [BarCommand]
-- infoBars = infoBars' screenConf

-- infoBars' :: Screens -> [BarCommand]
-- infoBars' conf = spawnBar <$> vegeta `concatMap` with_offset conf

with_offset :: Screens -> [(Screen, Int)]
with_offset conf = (\(screen,label) -> (screen, screen_offset conf label)) <$> screens
  where screens = get_screens' conf

spawnBars :: Screens -> [BarCommand]
spawnBars conf = spawnBars' `concatMap` with_offset conf 


spawnBars' :: (Screen, Int) -> [BarCommand]
spawnBars' (screen, offset) =  spawnBar <$> options
    where conkys = fmap conky <$> to_conky <$> bars screen
          widths = width <$> bars screen
          offsets = [ offset + sum (take n widths) | n <- [0..] ]
          aligns = align <$> bars screen 
          options' = zip4 conkys widths offsets aligns
          options = mapFst4 fromJust <$> filter (\(m,_,_,_) -> isJust m) options'

-- vegeta :: (Screen, Int) -> [(String, Int, Int, String)]
-- vegeta (screen, screen_offset) = (\x -> (conky x <> "Bar", conky_width x + blank_space, screen_offset, align x)) <$> bars'
--     where bars' = filter (not . isLog) $ bars screen
--           blank_space = (width screen - (sum $ conky_width <$> bars')) `div` length (bars screen) - 1

spawnBar :: (String, Int, Int, String) -> BarCommand
spawnBar (conky, width, offset, align) = cmd ++ conky ++ " | " ++ dzen
    where cmd = "conky -c ~/.xmonad/conky/"
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
    where bars' = spreadBars len bars
          bars'' = snd $ mapAccumL (\x (s, l) -> (x + l, (s, l, x, "c") )) off bars'

-- | Adds spaces among bars given the length of the target screen
spreadBars :: Int -> [(String, Int)] -> [(String, Int)]
spreadBars _ [] = []
spreadBars len bars = bars''
  where needed = sum $ snd <$> bars
        space = (len - needed) `div` length bars
        luckies = mod space (length bars)
        bars' = mapSnd (+ space) <$> bars
        bars'' = (mapSnd (+ 1) <$> take luckies bars') ++ drop luckies bars' 




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

mapSnd :: (a -> b) -> (c, a) -> (c, b)
mapSnd f (x,y) = (x,f y)

mapFst f (x,y) = (f x, y)

mapFst4 f (a,b,c,d) = (f a, b, c, d)
uncurry4 f (a,b,c,d) = f a b c d

---------------------------------------------------------
