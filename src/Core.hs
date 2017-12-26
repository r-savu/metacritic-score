module Core where

import           Control.Exception
import           Data.List
import           Network.HTTP
import           Text.HTML.TagSoup
import           Text.Read
import           Types

findGame :: String -> [Game] -> Maybe Game
findGame bytitle = find (\game -> title game == bytitle)

parseGame :: [Tag String] -> Maybe Game
parseGame tags = Game parsedTitle <$> maybeScore
   where
      innerTextFrom match = innerText . take 3 . concat . sections match
      parsedTitle = innerTextFrom (~== "<h3 class=\"product_title\">") tags
      maybeScore = readMaybe . innerTextFrom (~== "<span>") $ tags

openURL :: String -> IO (Maybe String)
openURL url = (Just <$> (getResponseBody =<< simpleHTTP (getRequest url)))
  `catch` exceptionHandler

exceptionHandler :: SomeException -> IO (Maybe String)
exceptionHandler _ = putStrLn "metacritic not reachable" >> pure Nothing

parseSections :: String -> [[Tag String]]
parseSections = sections (~== "<div class=\"main_stats\">") . parseTags
