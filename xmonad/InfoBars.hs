module InfoBars (logBar, infoBars, conkyIcon) where

import Data.List
import Control.Monad.Reader

data ScreenBar = SB { 
                      screen1 :: Int   -- length in pixels
                    , screen2 :: Int   -- length in pixels
                    , screen3 :: Int   -- length in pixels
                    , logLength :: Int -- length in pixels
                    , logBarScreen :: Int  -- Must be in [1,2,3] 
                    } deriving (Eq, Show, Ord)


-- | This is the configuration that wil be used
myConf = c_1280_1920
-- myConf = c_1280

c_1280_1920 = SB 1280 1920 0 1400 2
-- c_1280 = SB 0 1280 0 800 2

-- | Single 1920 screen
-- No status bars
-- l_1920 :: ScreenBar
-- l_1920 = SB 1920 0 0 1920 1


-- | The conky filename and its minimum length in pixels
bars1 :: [(String, Int)]
bars1 = [
          ("wifiBar", 300)
        , ("ethernetBar", 300)
        , ("cpuBar", 260)
        , ("fsBar", 400) 
        ]


bars2 :: [(String, Int)]  
bars2 = [
          ("clockBar", 80)
        , ("dateBar", 240)
        , ("archBar", 120)
        , ("soundBar", 80)
        ]


bars3 :: [(String, Int)]  
bars3 = [
        
        ]


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
infoBars = runReader infoBars' myConf

logBar :: BarCommand
logBar = runReader logBar' myConf
-------------------------------------------------

type MyConfig = Reader ScreenBar

log_screen :: MyConfig Int
log_screen = asks logBarScreen 

log_length :: MyConfig Int
log_length = asks logLength

prev_offset :: Int -> MyConfig Int
prev_offset screen = do
    conf <- ask
    let ls = [screen1 conf, screen2 conf, screen3 conf]
    return $ sum $ take (screen -1)  ls

x_offset :: Int -> MyConfig Int
x_offset screen = do
    s <- log_screen
    x <- prev_offset screen
    w <- log_length
    return $ if screen == s then x+w else x


infoBars' :: MyConfig [BarCommand]
infoBars' = do
    left <- infoBars'' 1
    middle <- infoBars'' 2
    right <- infoBars'' 3
    return $ left ++ middle ++ right

infoBars'' :: Int -> MyConfig [BarCommand]
infoBars'' screen = do
    let f = [screen1, screen2, screen3] !! (screen -1)
    len <- asks f
    x <- x_offset screen
    let bars = [bars1, bars2, bars3] !! (screen -1)
    l <- log_length
    s <- log_screen
    let space = if s == screen then len-l else len
    return $ spawnAll x space bars


logBar' :: MyConfig BarCommand
logBar' = do
    s <- log_screen
    x <- x_offset s
    w <- log_length
    return $ mkDzen' (x-w) w "l"





spawnBar :: (String, Int, Int, String) -> String
spawnBar (conky, width, offset, align) = cmd ++ conky ++ " | " ++ dzen
    where cmd = "conky -c ~/.xmonad/conky/"
          dzen = mkDzen' offset width align


spawnAll :: Int
         -- ^ Horizontal offset in pixels
         -> Int
         -- ^ Length of screen size in pixels 
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

