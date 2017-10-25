library("tidyverse")
library("nycflights13")
library("viridis")

flight_data <- flights
airlines_data <- airlines
airports_data <- airports
planes_data <- planes
weather_data <- weather


# Imagine you wanted to draw (approximately) the route each plane flies from its origin to its destination. 
# What variables would you need? What tables would you need to combine?

# airports_data latitude and longitude
# flight_data carrier, origin, and destination


# Add a surrogate key to flights
identical(length(flight_data$tailnum), length(unique(flight_data$tailnum)))

flight_data <- flight_data %>% 
  mutate(flight_entry = row_number())

identical(length(flight_data$flight_entry), length(unique(flight_data$flight_entry)))

#Add the location of the origin and destination (i.e. the lat and lon) to flights
test <- flight_data %>% 
  left_join(select(airports_data, faa, lat, lon), by = c("origin" = "faa")) %>% 
  rename(origin_lat = lat, origin_lon = lon) %>% 
  left_join(select(airports_data, faa, lat, lon), by = c("dest" = "faa")) %>% 
  rename(dest_lat = lat, dest_lon = lon)


#Is there a relationship between the age of a plane and its delays?
flight_data %>% 
  select(tailnum, arr_delay) %>% 
  left_join(select(planes_data, tailnum, year), by = "tailnum") %>% 
  ggplot(aes(year, log2(arr_delay + 1))) + 
  geom_bin2d() + 
  geom_smooth(color = "red", se = FALSE, size = 2) + 
  theme_bw() + 
  labs(x = "Year", y = expression(Log["2"]~Arrival~Delay~(mins)))



# What does anti_join(flights, airports, by = c("dest" = "faa")) tell you? 
# What does anti_join(airports, flights, by = c("faa" = "dest")) tell you?


# Tells you all flights that do not match in the airports data set but are in flights

# Tells you all airports that do not match in the flights data set but are in airports







