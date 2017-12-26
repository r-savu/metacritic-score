{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}

module Types where

import           Data.Aeson
import           Data.Aeson.TH
import           Servant
import           Text.HTML.TagSoup

data Game = Game
  { title :: String
  , score :: Int
  } deriving (Eq, Show)

$(deriveJSON defaultOptions ''Game)

type API = "games" :> Get '[JSON] [Game]
      :<|> "games" :> Capture "title" String :> Get '[JSON] Game

api :: Proxy API
api = Proxy
