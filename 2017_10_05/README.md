
## R for Data Science Lab Meeting Materials
### Chapters 9-11

In general this lesson involves looking at how to handle data structures within the `tidyverse` ecosystem. This is not the only way to manage your data from graphical purposes but it is a nice integrated environment that provides many tools that you can customize for your own use to make managing and transforming data easier and more manageable.

**The main components of "Wrangling" your data are as follows:**

![examle_image](http://r4ds.had.co.nz/diagrams/data-science-wrangle.png)

For this session we are going to split into teams to tackle a select number of questions for chapters 10 and 11. The teams for this session are going to be:

Team 1: Nick and Ada  
Team 2: Kaitlin and Pat  
Team 3: Filipe and Will  

Charlie can choose which team he would like to join. There will not be a lot of coding per se. Instead we will focus on more higher level concepts and then come together to discuss each of the questions.

*The breakdown will be as follows:*  
* 30 minutes to work through the questions  
* 20 minutes to discuss the questions  
* 10 minutes for general questions on chapters 9-11  

**Questions**

1) What are the pros and cons with using a tibble?
2) Given the function below, what are the most important arguments?   
```
read_fwf(file, col_positions, col_types = NULL, locale = default_locale(), 
        na = c("", "NA"), comment = "", skip = 0, n_max = Inf, 
        guess_max = min(n_max, 1000), progress = show_progress())
```
3) Identify what is wrong with each of the following inline CSV files. What happens when you run the code?
```
read_csv("a,b\n1,2,3\n4,5,6")
read_csv("a,b,c\n1,2\n1,2,3,4")
read_csv("a,b\n\"1")
read_csv("a,b\n1,2\na,b")
read_csv("a;b\n1;3")
```
4) What problems can occur when parsing numbers, strings, factors, or dates(date-times, etc.)?

5) What if any benefits or disadvantages are there for using the `read_csv` or `read.csv` functions?


**Other types of data:**

* `.xls` or `.xlsx` can use special packages such as readxl
  * I've had a bad experience with these and now store everything default as `.csv`
  
* SQL databases can be queried using the DBI package
  * Many complicated data structures are stored in this way (e.g. Relational Databases)
  ![example_RDB](http://database.guide/wp-content/uploads/2016/06/sakila_full_database_schema_diagram.png)
  
* Can always refer to the end of [Chapter 11](http://r4ds.had.co.nz/data-import.html) for other programs that read specialized data types into R
