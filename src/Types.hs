{-# LANGUAGE OverloadedStrings #-}

module Types where

import           Control.Monad
import           Data.Aeson

apiBase :: String
apiBase = "https://www.binance.com/api/v1/"

newtype TimeResponse = TimeResponse {
  serverTime :: Integer
} deriving Show

data DepthRequest = DepthRequest {
  symbol :: String ,
  limit  :: Integer
} deriving Show

data DepthResponse = DepthResponse {
  lastUpdateId :: Integer ,
  bids         :: [String] ,
  asks         :: [String]
} deriving Show

instance ToJSON DepthRequest where
  toJSON (DepthRequest symbol limit) = object ["symbol" .= symbol, "limit" .= limit]

instance FromJSON TimeResponse where
  parseJSON (Object t) = TimeResponse
                         <$> t .: "serverTime"

instance FromJSON DepthResponse where
  parseJSON (Object d) = DepthResponse
                         <$> d .: "lastUpdateId"
                         <*> d .: "bids"
                         <*> d .: "asks"
