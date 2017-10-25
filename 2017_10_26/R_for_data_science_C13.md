# R for Data Science Lab Meeting Materials
### Chapter 13

**Introduction**

This chapter goes into more detail into some of the concepts covered within chapters 9-11. Specifically, it deals with how to work with relational data and the tools that the `tidyverse` provides to facilitate this. For this session we will be working exclusively with the `nycflights13` database so make sure you have that installed on your computer. 

What you see below ([click here if image doesn't show up](http://r4ds.had.co.nz/diagrams/relational-nycflights.png)) in the image is an example of the relations that exist between the different data tables and the flights data. What are the advantages with having data stored in this way? Are there any disadvantages?

![relational_data_image](http://r4ds.had.co.nz/diagrams/relational-nycflights.png)  



**Chapter Workthrough Overview**

There are a series of questions that are pulled from the chapter directly. We will break into groups and work through these questions. We can then come back together and compare the different ways in which we chose to solve the problem.

Groups:  
* Marc and Charlie  
* Ada and Pat
* Nick and Will
* Kaitlin and Marian (or join one of the other groups if Marian can not attend)

Time Allotment:  
* 40 minutes for questions
* 20 minutes for discussion

Questions: 
1. *Imagine you wanted to draw (approximately) the route each plane flies from its origin to its destination. 
What variables would you need? What tables would you need to combine?*

2. *Add a surrogate key to flights*

3. *Add the location of the origin and destination (i.e. the lat and lon) to flights*

4. *Is there a relationship between the age of a plane and its delays?*

5. *What does anti_join(flights, airports, by = c("dest" = "faa")) tell you? What does anti_join(airports, flights, by = c("faa" = "dest")) tell you?*



