{-# LANGUAGE OverloadedStrings #-}

module Data.Aviation.Stratux.Demo where

import Control.Applicative((<*>))
import Control.Concurrent(threadDelay)
import Control.Monad(forever)
import Control.Monad.IO.Class(MonadIO(liftIO))
import Control.Monad.Trans.Either(EitherT, runEitherT)
import Data.Aviation.Stratux
import Data.String(String)
import Control.Lens((^.), Getting)
import Data.Bool(Bool)
import Data.Either(Either)
import Data.Function(($))
import Data.Functor((<$>))
import Data.Int(Int)
import Data.Text(Text)
import Data.Time(UTCTime)
import Network.URI(URIAuth(URIAuth))
import Prelude(Double, Show)
import System.IO(IO, print)

run ::
  EitherT a f b
  -> f (Either a b)
run =
  runEitherT

tmorrisuri ::
  String
tmorrisuri =
  "ws.stratux.tmorris.net"

tmorrisport ::
  Int
tmorrisport =
  80

tmorrisuriauth ::
  URIAuth
tmorrisuriauth =
  (URIAuth "" tmorrisuri "")

thesituation ::
  EitherT String IO Situation
thesituation =
  getSituation tmorrisuriauth "" "" 

onthesituation ::
  Getting a Situation a
  -> EitherT String IO a
onthesituation g =
  (^. g) <$> thesituation

thepressurealtitude ::
  EitherT String IO Double
thepressurealtitude =
  onthesituation pressureAlt

thepitch ::
  EitherT String IO Double
thepitch =
  onthesituation pitch

theroll ::
  EitherT String IO Double
theroll =
  onthesituation roll

theheading ::
  EitherT String IO Double
theheading =
  onthesituation gyroHeading

thetemp ::
  EitherT String IO Double
thetemp =
  onthesituation temp

thelatitude ::
  EitherT String IO Double
thelatitude =
  onthesituation lat

thelongitude ::
  EitherT String IO Double
thelongitude =
  onthesituation lon

theposition ::
  EitherT String IO (Double, Double)
theposition =
  (,) <$> thelatitude <*> thelongitude

theaccuracy ::
  EitherT String IO Double
theaccuracy =
  onthesituation accuracy

theverticalspeed ::
  EitherT String IO Double
theverticalspeed =
  onthesituation gpsVertVel

theverticalaccuracy ::
  EitherT String IO Double
theverticalaccuracy =
  onthesituation accuracyVert

theheight ::
  EitherT String IO Double
theheight =
  onthesituation heightAboveEllipsoid

thecourse ::
  EitherT String IO Double
thecourse =
  onthesituation trueCourse

thegroundspeed ::
  EitherT String IO Int
thegroundspeed =
  onthesituation groundSpeed

loop ::
  (MonadIO f, Show a) =>
  Int
  -> f a
  -> f ()
loop d x =
  forever $
    do  a <- x
        liftIO (print a)
        liftIO (threadDelay d)

loop4 ::
  (MonadIO f, Show a) =>
  f a
  -> f ()
loop4 =
  loop 250000

----

thetraffic ::
  (Either String Traffic -> IO a)
  -> IO ()
thetraffic f =
  trafficApp tmorrisuri tmorrisport f ("" :: Text)

thetrafficpart ::
  Getting b Traffic b
  -> (Either String b -> IO a)
  -> IO ()
thetrafficpart g f =
  thetraffic (\e -> f ((^. g) <$> e))

theicaoaddr ::
  (Either String IcaoAddr -> IO a)
  -> IO ()
theicaoaddr =
  thetrafficpart icaoAddr

thetail ::
  (Either String String -> IO a)
  -> IO ()
thetail =
  thetrafficpart tail

theemittercategory ::
  (Either String EmitterCategory -> IO a)
  -> IO ()
theemittercategory =
  thetrafficpart emitterCategory

theonground ::
  (Either String Bool -> IO a)
  -> IO ()
theonground =
  thetrafficpart onGround

theaddresstype ::
  (Either String Int -> IO a)
  -> IO ()
theaddresstype =
  thetrafficpart addressType

thetargettype ::
  (Either String TargetType -> IO a)
  -> IO ()
thetargettype =
  thetrafficpart targetType

thesignallevel ::
  (Either String Double -> IO a)
  -> IO ()
thesignallevel =
  thetrafficpart signalLevel

thepositionvalid ::
  (Either String Bool -> IO a)
  -> IO ()
thepositionvalid =
  thetrafficpart positionValid

thealtitude ::
  (Either String Int -> IO a)
  -> IO ()
thealtitude =
  thetrafficpart altitude

thegnssdifffrombaroalt ::
  (Either String Int -> IO a)
  -> IO ()
thegnssdifffrombaroalt =
  thetrafficpart gnssDiffFromBaroAlt

thealtisgnss ::
  (Either String Bool -> IO a)
  -> IO ()
thealtisgnss =
  thetrafficpart altIsGnss

thenavigationintegritycategory ::
  (Either String Int -> IO a)
  -> IO ()
thenavigationintegritycategory =
  thetrafficpart navigationIntegrityCategory

thenavigationaccuracycategoryforposition ::
  (Either String Int -> IO a)
  -> IO ()
thenavigationaccuracycategoryforposition =
  thetrafficpart navigationAccuracyCategoryForPosition

thetrack ::
  (Either String Int -> IO a)
  -> IO ()
thetrack =
  thetrafficpart track

thespeed ::
  (Either String Int -> IO a)
  -> IO ()
thespeed =
  thetrafficpart speed

thespeedvalid ::
  (Either String Bool -> IO a)
  -> IO ()
thespeedvalid =
  thetrafficpart speedValid

theverticalvelocity ::
  (Either String Int -> IO a)
  -> IO ()
theverticalvelocity =
  thetrafficpart verticalVelocity

thetimestamp ::
  (Either String UTCTime -> IO a)
  -> IO ()
thetimestamp =
  thetrafficpart timestamp

theage ::
  (Either String Double -> IO a)
  -> IO ()
theage =
  thetrafficpart age

thelastseen ::
  (Either String UTCTime -> IO a)
  -> IO ()
thelastseen =
  thetrafficpart lastSeen

thelastaltitude ::
  (Either String UTCTime -> IO a)
  -> IO ()
thelastaltitude =
  thetrafficpart lastAltitude

thelastgnssdiff ::
  (Either String UTCTime -> IO a)
  -> IO ()
thelastgnssdiff =
  thetrafficpart lastGnssDiff

thelastgnssdiffaltitude ::
  (Either String Int -> IO a)
  -> IO ()
thelastgnssdiffaltitude =
  thetrafficpart lastGnssDiffAltitude

thelastspeed ::
  (Either String UTCTime -> IO a)
  -> IO ()
thelastspeed =
  thetrafficpart lastSpeed

thelastsource ::
  (Either String Int -> IO a)
  -> IO ()
thelastsource =
  thetrafficpart lastSource

theextrapolatedposition ::
  (Either String Bool -> IO a)
  -> IO ()
theextrapolatedposition =
  thetrafficpart extrapolatedPosition

thebearing ::
  (Either String Double -> IO a)
  -> IO ()
thebearing =
  thetrafficpart bearing

thedistancetotrafficfromownship ::
  (Either String Double -> IO a)
  -> IO ()
thedistancetotrafficfromownship =
  thetrafficpart distanceToTrafficFromOwnship
