{-# LANGUAGE OverloadedStrings #-}

module Types where

import           Control.Monad
import           Data.Aeson
import           Data.Foldable (asum)

apiBase :: String
apiBase = "https://www.binance.com/api/v1/"

data DepthRequest = DepthRequest {
  symbol :: String ,
  limit  :: Integer
} deriving Show

data ServerResponse
  = Time { serverTime :: Integer }
  | Ping { blank :: String }
  deriving Show

instance ToJSON DepthRequest where
  toJSON (DepthRequest symbol limit) = object ["symbol" .= symbol, "limit" .= limit]

instance FromJSON ServerResponse where
  parseJSON = withObject "time or ping" $ \o -> asum [
    Time <$> o.: "serverTime",
    Ping <$> o.: "blank" ]
