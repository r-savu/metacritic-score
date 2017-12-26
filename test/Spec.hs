import           Core
import           Test.HUnit
import           Text.HTML.TagSoup
import           Types

gamesList = [ Game "title1" 1
            , Game "random" 5
            , Game "kicker" 3
            ]

parseGameSuccess = do
  html <- readFile "test/okamiSample.html"
  let game = parseGame . parseTags $ html
  assertEqual "parse successful" game (Just $ Game "Okami HD" 88)

parseGameFail = do
  let parseError = parseGame . parseTags $ "nonsense"
  assertEqual "parse error" parseError Nothing

findGameSuccess = do
  let someGame = findGame "random" gamesList
  assertEqual "find by title" someGame (Just $ gamesList !! 1)

findGameFail = do
  let noGame = findGame "not in here" gamesList
  assertEqual "not found" noGame Nothing

main :: IO Counts
main = runTestTT $ test
  [ "Parse Game" ~: parseGameSuccess
  , "Parse Fail" ~: parseGameFail
  , "Find Game" ~: findGameSuccess
  , "Find Fail" ~: findGameFail
  ]
