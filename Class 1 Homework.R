# 1. Install and load the gcookbook and tidyverse library 

library(gcookbook)
library(tidyverse)

# 2. Create a dataset called df using the heightweight dataframe included in the library


# Check: You should now have a dataset in your environment with 236 obs. and 5 variables 
# This dataset contains Sex, Age, Height and Weight information of schoolchildren 
# ageYear is age in years
# ageMonth is age in moths 
# heightIn is height in inches
# weightLb is weight in pounds


# 3. Lets look at factor data first (Sex)
# create a bar graph to see sex distribution in your data. What is the predominant sex?
# hint: go with the default stat

# Answer: Male

# 4. Now lets look at height and weight distribution
# create a scatter plot of Weight vs Age in Years 


# now lets add a 3rd component and map the observations to color 
# color the data points according to height  


# now lets add one more component
# size the data points according to sex 


# ok, thats not very useful
# notice the warning in the console
# lets try size by weight and color by sex instead

# When you map a continuous variable to an aesthetic, you can still map a categorical variable to other aesthetics 
# Plot looks better but still hard to see. Lets add some transparency by setting alpha = .5
# hint: alpha is just a different aesthetic, code it just as size or color 


# 5. Finally, let's go back to our original Height vs. Weight Scatter plot and fit a couple of regression lines 
# first a simple linear regression


# do a linear regression to estimate weightLb based on ageYear
# save as mod1 


#using the the regression output calculate the estimated weight for a 13 year old 


# now go back to the plot and add a local regression to that same plot 
# color = "red" to differentiate 

