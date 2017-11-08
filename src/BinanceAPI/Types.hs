{-# LANGUAGE DeriveDataTypeable    #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ScopedTypeVariables   #-}

module BinanceAPI.Types where

import           Control.Applicative
import           Control.Monad
import           Data.Aeson
import           Data.Aeson.Types    (typeMismatch)
import           Data.Data
import           Data.Foldable       (asum)
import qualified Data.Vector         as V (Vector, mapM, toList)

responses :: String
responses = "time or ping or depth or aggtrades or klines or twfh"

data ArrayServerResponse
  = Kline { openTime :: Integer, open :: String, high :: String, low :: String, close :: String, volume :: String, closeTime :: Integer
  , quoteAssetVolume :: String, numberOfTrades :: Integer, buyBaseVolume :: String, buyQuoteVolume :: String, ignore :: String }
  | AggTrade { a :: Integer, p :: String, q :: String, f :: Integer, l :: Integer, t :: Integer, m :: Bool, m :: Bool }
  deriving (Show, Typeable, Data)

data ServerResponse
  = Time { serverTime :: Integer }
  | Ping { blank :: String }
  | Depth { lastUpdateId :: Integer, bids :: [[String]], asks :: [[String]]}
  | AggTrades { trades :: [ArrayServerResponse] }
  | Klines { klinesList :: [ArrayServerResponse] }
  | TWFH { priceChange :: String, priceChangePercent :: String, weightedAvgPrice :: String, prevClosePrice :: String, lastPrice :: String
         , bidPrice :: String, askPrice :: String, openPrice :: String, highPrice :: String, lowPrice :: String, volume :: String
         , openTime :: Integer, closeTime :: Integer, firstId :: Integer, lastId :: Integer, count :: Integer}
  deriving (Show, Typeable)

instance FromJSON ArrayServerResponse where
  parseJSON (Object o) = asum [
        Kline <$> o .: "openTime" <*> o .: "open" <*> o .: "high" <*> o .: "low" <*> o .: "close" <*> o .: "volume" <*> o .: "closeTime"
        <*> o .: "quoteAssetVolume" <*> o .: "numberOfTrades" <*> o .: "buyBaseVolume" <*> o .: "buyQuoteVolume" <*> o .: "ignore",
        AggTrade <$> o .: "a" <*> o .: "p" <*> o .: "q" <*> o .: "f" <*> o .: "l" <*> o .: "T" <*> o .: "m" <*> o .: "M" ]
  parseJSON _ = error "poo"

-- TODO: Revisit this, 100% a much better way to do this but in a rush
instance FromJSON ServerResponse where
  parseJSON (Object o) = asum [
    Ping <$> o .: "blank",
    Time <$> o .: "serverTime",
    Depth <$> o .: "lastUpdateId" <*> o .: "bids" <*> o .: "asks",
    TWFH <$> o .: "priceChange" <*> o .: "priceChangePercent" <*> o .: "weightedAvgPrice" <*> o .: "prevClosePrice"  <*> o .: "lastPrice"
        <*> o .: "bidPrice" <*> o .: "askPrice" <*> o .: "openPrice" <*> o .: "highPrice" <*> o .: "lowPrice" <*> o .: "volume"
        <*> o .: "openTime" <*> o .: "closeTime" <*> o .: "firstId" <*> o .: "lastId" <*> o .: "count"]
  parseJSON (Array a) = do
    let l = V.toList a
    case head l of
      (Object _) -> do
        asr :: [ArrayServerResponse] <- mapM parseJSON l
        return $ AggTrades asr
      (Array _) -> do
        let innerList = V.toList <$> l
        return . Klines $ Kline $ createKline <$> innerList
          where createKline (String s) = String s
                createKline (Number n) = Number n

  parseJSON _ = error "Y r u here"

-- instance ToJSON TypedRequestBody where
--   toJSON (DepthRequest symbol limit) = object [ "symbol" .= symbol, "limit" .= limit ]

data TypedRequestBody
  = DepthRequest { symbol :: String, limit :: Integer }
    deriving Show
