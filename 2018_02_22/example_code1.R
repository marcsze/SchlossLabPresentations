## Code from the repo - https://github.com/microbiome
## Main contributors are 
  # Leo Lahti - https://github.com/antagomir
  # Sudar Shan - https://github.com/microsud
## Both are in Computer Science Departments

####################### Example Code ############################################


# x: Species count vector
simpson_evenness <- function(x, zeroes=TRUE) {
  
  if (!zeroes) {
    x[x > 0]
  }
  
  # Species richness (number of species)
  S <- length(x)
  
  # Relative abundances
  p <- x/sum(x)
  
  # Simpson index
  lambda <- sum(p^2)
  
  # Simpson evenness (Simpson diversity per richness)
  (1/lambda)/S
  
}




# x: Species count vector
pielou <- function(x) {
  
  # Remove zeroes
  x <- x[x > 0]
  
  # Species richness (number of species)
  S <- length(x)
  
  # Relative abundances
  p <- x/sum(x)
  
  # Shannon index
  H <- (-sum(p * log(p)))
  
  # Simpson evenness
  H/log(S)
  
}