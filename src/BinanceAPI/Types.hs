{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings     #-}

module BinanceAPI.Types where

import           Control.Applicative
import           Control.Monad
import           Data.Aeson
import           Data.Foldable       (asum)
import qualified Data.Vector         as V (mapM, toList)
import           GHC.Generics

responses :: String
responses = "time or ping or depth or aggtrades or klines or twfh"

data Kline = Kline Integer String String String String String Integer String Integer String String String deriving (Show, Generic)

data AggTrade = AggTrade { a :: Integer, p :: String, q :: String, f :: Integer, l :: Integer, t :: Integer, m :: Bool, mm :: Bool }
  deriving (Show, Generic)

instance FromJSON Kline
instance FromJSON AggTrade

data ServerResponse
  = Time { serverTime :: Integer }
  | Ping { blank :: String }
  | Depth { lastUpdateId :: Integer, bids :: [[String]], asks :: [[String]]}
  | AggTrades { trades :: [AggTrade] }
  | Klines { k :: [Kline] }
  | TWFH { priceChange :: String, priceChangePercent :: String, weightedAvgPrice :: String, prevClosePrice :: String, lastPrice :: String
         , bidPrice :: String, askPrice :: String, openPrice :: String, highPrice :: String, lowPrice :: String, volume :: String
         , openTime :: Integer, closeTime :: Integer, firstId :: Integer, lastId :: Integer, count :: Integer}
  deriving Show

instance FromJSON ServerResponse where
  parseJSON (Object o) = asum [
    Ping <$> o .: "blank",
    Time <$> o .: "serverTime",
    Depth <$> o .: "lastUpdateId" <*> o .: "bids" <*> o .: "asks",
    TWFH <$> o .: "priceChange" <*> o .: "priceChangePercent" <*> o .: "weightedAvgPrice" <*> o .: "prevClosePrice"  <*> o .: "lastPrice"
        <*> o .: "bidPrice" <*> o .: "askPrice" <*> o .: "openPrice" <*> o .: "highPrice" <*> o .: "lowPrice" <*> o .: "volume"
        <*> o .: "openTime" <*> o .: "closeTime" <*> o .: "firstId" <*> o .: "lastId" <*> o .: "count"]
  --parseJSON (Array a) =
  parseJSON _ = error "Y r u here"

-- instance ToJSON TypedRequestBody where
--   toJSON (DepthRequest symbol limit) = object [ "symbol" .= symbol, "limit" .= limit ]

data TypedRequestBody
  = DepthRequest { symbol :: String, limit :: Integer }
    deriving Show
