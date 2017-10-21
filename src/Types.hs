{-# LANGUAGE OverloadedStrings #-}

module Types where

import           Control.Monad
import           Data.Aeson
import           Data.Foldable (asum)

apiBase :: String
apiBase = "https://www.binance.com/api/v1/"

noArg :: Int
noArg = 0

singleArg :: Int
singleArg = 1

data ServerResponse
  = Time { serverTime :: Integer }
  | Ping { blank :: String }
  deriving Show

data TypedRequestBody
  = Depth { symbol :: String, limit :: Integer }
  deriving Show

instance ToJSON TypedRequestBody where
  toJSON (Depth symbol limit) = object ["symbol" .= symbol, "limit" .= limit]

instance FromJSON ServerResponse where
  parseJSON = withObject "time or ping" $ \o -> asum [
    Ping <$> o .: "blank" ,
    Time <$> o .: "serverTime" ]
