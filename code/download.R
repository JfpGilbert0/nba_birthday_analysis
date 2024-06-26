### Download raw data ###
# USE: to be run first to download datasets from nbastatR API. It is reccomended that you only download the pbp data as all these databases are quite large.
# Author: Jacob Gilbert 
# Date: 19 April 2024
# Contact: j.gilbert@mail.utoronto.ca
# License: MIT
# Pre-requisites: NA


# setup
library(tidyverse)
library(rvest)
library(nbastatR)
library(lubridate)
library(janitor)
library(heapsofpapers)
library(arrow)
Sys.setenv("VROOM_CONNECTION_SIZE" = 500000)
# Data from nbaR
gamedata <- clean_names(game_logs(seasons = 2022, season_types = c("Regular Season")))
playoffdata <- clean_names(game_logs(seasons = 2022, season_types = c("Playoff")))
# Save raw
write_parquet(x = gamedata, sink ="data/raw/gamedata.parquet")
write_parquet(x = playoffdata, sink = "data/raw/playoffdata.parquet")
#
raps <- teams_annual_stats(teams = "Toronto Raptors")


season <- teams_seasons_info(seasons = 2022)
season_data <- clean_names(nbastatR::seasons_players(seasons = 2012:2022))
# Save raw
write_parquet(x = season_data, sink ="data/raw/seasondata.parquet")

#Play-By-Play: Split season into 3 for speed
pbp_1 <- play_by_play_v2(game_ids = 22100001:22100600)
write_parquet(x = pbp_1, "data/raw/pbp2022_1.parquet")
pbp_2 <- play_by_play_v2(game_ids = 22100601:22101200)
write_parquet(x = pbp_2, "data/raw/pbp2022_2.parquet")
pbp_3 <- play_by_play_v2(game_ids = 22101201:22101230)
write_parquet(x = pbp_3, "data/raw/pbp2022_3.parquet")
play_by_play_v2(game_ids = 22100604)

# merge play-by-play data
pbp <- rbind(pbp1, pbp2)
pbp <- rbind(pbp, pbp3)

#Creating a 4th quarter db
pbp_4th <- pbp |>
    filter(number_period == 4)
#save raw
write_parquet(x = pbp_4th, sink = "data/analysis/pbp_4thonly")
