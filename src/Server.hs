{-# LANGUAGE OverloadedStrings #-}

module Server (startApp) where

import           Control.Monad.Except
import           Core
import           Data.Maybe
import           Network.Wai.Handler.Warp
import           Network.Wai.Logger       (withStdoutLogger)
import           Servant
import           Types

startApp :: IO ()
startApp = withStdoutLogger $ \aplogger -> do
  let settings = setPort 1234 $ setLogger aplogger defaultSettings
  runSettings settings app

app :: Application
app = serve api server

server :: Server API
server = getGameList :<|> getGame

getGameList :: Handler [Game]
getGameList = do
  html <- liftIO . openURL $ "http://www.metacritic.com/game/playstation-4"
  when (isNothing html) . throwError
    $ err500 { errBody = "Can not reach metacritic.com" }
  let items = parseSections . fromJust $ html
  let parseErrHandler = err500 { errBody = "Can not parse content" }
  mapM (handleMaybe parseErrHandler . parseGame) items

getGame :: String -> Handler Game
getGame t =  handleMaybe err404 . findGame t =<< getGameList

handleMaybe :: ServantErr -> Maybe a -> Handler a
handleMaybe err x = case x of
  Nothing    -> throwError err
  Just value -> pure value
