{-# LANGUAGE OverloadedStrings #-}

module Types where

import           Control.Monad
import           Data.Aeson
import           Data.Foldable (asum)

responses :: String
responses = "time or ping or depth"

data ServerResponse
  = Time { serverTime :: Integer }
  | Ping { blank :: String }
  | Depth { lastUpdateId :: Integer, bids :: [[String]], asks :: [[String]]}
  deriving Show

data TypedRequestBody
  = DepthRequest { symbol :: String, limit :: Integer }
  deriving Show

instance FromJSON ServerResponse where
  parseJSON = withObject responses $ \o -> asum [
    Ping <$> o .: "blank" ,
    Time <$> o .: "serverTime",
    Depth <$> o .: "lastUpdateId"
          <*> o .: "bids"
          <*> o .: "asks" ]
