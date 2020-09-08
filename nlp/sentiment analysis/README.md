# Clothing E-Commerce Reviews Sentiment Analysis

Nowadays customers can express their thoughts more openly than ever before and people tend to rely on these opinions to help them make decisions. A positive or negative review might dramatically influence a brand's image. Therefore, it is important for businesses to listen attentively to their customers and react promptly. By understanding customers' likes and dislikes, brands can improve their products to meet their needs. Besides, businesses are able to get insights that help develop strategies, such as marketing plans for different customer segments. 

This analysis consists of two parts. In the part 1, I will perform an exploratory analysis to have a initial understanding of our data. In the part 2, I will implement a Naïve Bayes algorithm I have built previously to conduct a binary classification.



## Data Overview

Women’s Clothing E-Commerce dataset is a real commercial data from [Kaggle](https://www.kaggle.com/nicapotato/womens-ecommerce-clothing-reviews). It revolves around the reviews written by customers and includes 9 variables. 

<p align="center">	
	<img align="middle" src="https://github.com/crystalwanyulee/data_science_projects/blob/master/nlp/sentiment%20analysis/images/Image_extra-1410.png?raw=true">
</p>




## Exploratory Analysis

There are 8748 reviews in our dataset. Over 80% of reviews are positive while less than 20% are negative. Overall, most of customers have great impression for dress products. It is a good news for businesses. However, it posts an imbalanced classification challenge because the number of positive reviews is far more than the other one. In addition, negative reviews generally is more important than positive reviews since they might cause damages to brands. To solve this problem and gain better results, I will consider other metrics rather than accuracy rate that people commonly used when training the model. 

<p align="center">	
	<img align="middle" src="https://github.com/crystalwanyulee/data_science_projects/blob/master/nlp/sentiment%20analysis/images/Sentiment of Clothing Reviews.png?raw=True">
</p>



When we break down each sentence and count the frequency for each word, the results are presented in the following graph. We can notice that most of the frequent words are preposition, pronoun, and conjunction. These words do not provide too much information in a sentence. This kind of words is also called **stop word**. Usually, they are used to construct a sentence, so they appear very commonly in a document, and they easily show up when considering frequent words. 



<p align="center">	
	<img align="middle" src="https://github.com/crystalwanyulee/data_science_projects/blob/master/nlp/sentiment%20analysis/images/Top 10 Frequent Words.png?raw=true">
</p>



However, stop words cannot help us catch a glimpse of the data. Thus, I remove them and calculate frequency again. The results are shown in below.  

<p align="center">	
	<img align="middle" src="https://github.com/crystalwanyulee/data_science_projects/blob/master/nlp/sentiment%20analysis/images/Top 10 Frequent Words (without stopwords).png?raw=true">
</p>

After removing stop words, the top 10 frequent words are totally different. If we categorize these words base on part-of-speech, then:

* **noun:** top, shirt, sweater, size, color 
* **verb:** love, like, wear, fit
* **adjective:** great




Then, I further perform word clouds to extract frequent words in positive reviews and negative reviews, respectively. The more frequent a word appears in reviews, the bigger it will become. It is worth mentioning that I remove some common but meaningless in this case, including stop words (such as “the”, “is” and “and”), dress-related words ('top' and 'shirt'), and verbs (such as "look" and "think"). 

<p align="center">	
	<img align="middle" src="https://github.com/crystalwanyulee/data_science_projects/blob/master/nlp/sentiment%20analysis/images/posneg_word_cloud_small.png?raw=true">
</p>



<p align="center">	
	<img align="middle" src="https://github.com/crystalwanyulee/data_science_projects/blob/master/nlp/sentiment%20analysis/images/Top Frequent Words (pos vs neg).png?raw=true">
</p>



Although I remove stop words in the exploratory analysis, I will not remove them when training models. Sometimes, discarding them may not help improve models. The best way is to let the machine to select features and filter out unnecessary words.



Now, let's look at sentence lengths. I calculate the number of words in each review and plot their distribution. The distribution in all reviews, positive ones and negative ones are similar. We can notice that there are two peaks in the distribution. The one is located within 20~40 words, and the other one is about 90 words. 

<p align="center">	
	<img align="middle" src="https://github.com/crystalwanyulee/data_science_projects/blob/master/nlp/sentiment%20analysis/images/Distirbution of Sentence Length.png?raw=true">
</p>



## Modeling Results



### 1. Training 

The model chooses 53 features during the training process. The results on the train set look pretty good. The accuracy rate achieves 0.857, which means the model can accurately predict 85.3% reviews and classify them into correct classes.

<p align="center">	
	<img align="middle" src="https://github.com/crystalwanyulee/data_science_projects/blob/master/nlp/sentiment%20analysis/images/image-20200905123050720.png?raw=true">
</p>


</br>

### 2. Testing

After building the classification model, it's time to apply the model on the testing set. The accuracy rate is 75.5% It's a little bit overfitting, but still have a good result. 

<p align="center">	
	<img align="middle" src="https://github.com/crystalwanyulee/data_science_projects/blob/master/nlp/sentiment%20analysis/images/image-20200905123023457.png?raw=true">
</p>



Now, we can take a close look at which words help the machine to conduct classification. Although the model selects 53 features, we do not know which features can be used to identify positive reviews and versa. Thus, I make use of the likelihood ratio to help determine their tones. Here is the formula:

<p align="center">
    <img width=300 height=50 src="https://latex.codecogs.com/gif.latex?Likelihood\;Ratio&space;=&space;\max_{i,j}\frac{P(w|c_i)}{P(w|c_j)}" title="Likelihood\;Ratio = \max_{i,j}\frac{P(w|c_i)}{P(w|c_j)}" />



At first, we have to calculate conditional probabilities, given that a word appears in positive reviews or negative reviews. Next, we can calculate two kinds of ratios: the positive-negative likelihood ratio and the negative-positive ratio. The former is to divide the positive probability by the negative probability, and the latter is to divide the negative probability by the positive probability. Lastly, by comparing two ratios, we can decide their tones. The following is the likelihood ratio calculation for the first 5 features. 

<p align="center">	
	<img align="middle" src="https://github.com/crystalwanyulee/data_science_projects/blob/master/nlp/sentiment%20analysis/images/image-20200905130008046.png?raw=true">
</p>



Take the word "comfortable" as an example. To calculate the likelihood ratio, first find out the conditional probabilities:

<p align="center">
    <img src="https://latex.codecogs.com/gif.latex?P(comfortable|positive)&space;=&space;0.001615" title="P(comfortable|positive) = 0.001615" /> </br>
   <img src="https://latex.codecogs.com/gif.latex?P(comfortable|negative)&space;=&space;0.000263" title="P(comfortable|negative) = 0.000263" />



Then, calculate the ratios:

<p align="center">
    <img src="https://latex.codecogs.com/gif.latex?Pos\text{-}Neg\;Ratio=\frac{P(\text{comfortable}|\text{pos})}{P(\text{comfortable}|\text{neg)}}=\frac{0.001615}{0.000263}=6.13" title="Pos\text{-}Neg\;Ratio=\frac{P(\text{comfortable}|\text{pos})}{P(\text{comfortable}|\text{neg)}}=\frac{0.001615}{0.000263}=6.13" /></br>
   <img src="https://latex.codecogs.com/gif.latex?Neg\text{-}Pos\;Ratio=\frac{P(\text{comfortable}|\text{pos})}{P(\text{comfortable}|\text{neg)}}=\frac{0.000263}{0.001615}=0.16" title="Neg\text{-}Pos\;Ratio=\frac{P(\text{comfortable}|\text{pos})}{P(\text{comfortable}|\text{neg)}}=\frac{0.000263}{0.001615}=0.16" />



Obviously, the positive-negative ratio is much higher than the other one, and thus we can regard "comfortable" as a positive word. 

However, If we look at the word "cheap", we can discover that its negative-positive ratio is far higher than its opposite one (25.43 > 30.66). Therefore, "cheap" can be labeled as a negative word in this case.

After computing all likelihood ratios, I select the top 10 positive and negative features and present the results below.

<p align="center">	
	<img align="middle" src="https://github.com/crystalwanyulee/data_science_projects/blob/master/nlp/sentiment%20analysis/images/Top Imporant Words for Classification.png?raw=true">
</p>




| Positive                                                     | Negative                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| **noun:** jeans, pants, drapes<br>**verb:** gives, run<br/>**adjective:** best, paired, wonderful, comfortable <br/>**adverb:** highly | **noun:** idea<br>**verb:** returned, hopes, expected, started, hung<br/>**adjective:** disappointed, cheap, poor, unflattering |



From the results, it seems that our customers like pants (especially jeans), clothing with drapes, and paired clothing sets.  

<p align="center">	
	<img align="middle" width='200' height='300' src="https://images.unsplash.com/photo-1547410701-73b5a0ada51d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=675&q=80">
    <img align="middle" width='200' height='300' src="https://images.unsplash.com/flagged/photo-1557310298-9d6633ff5b66?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=633&q=80">
    <img align="middle" width='200' height='300' src="https://images.unsplash.com/photo-1582517016090-78e80111a877?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=647&q=80">



In the negative part, there are several emotional words. From these words, we can guess that the customer tend to leave unfavorable reviews if clothes have a bad quality(cheap, poor) or terrible design(idea), make people looks terrible(unflattering).



## Conclusion and Application

* The sentiment analysis model can provide an outline of what customers think about our product. From the features that the model selected, they gives us some ideas about which aspects we can focus or improve. For example, from the classifiers, we can notice that customers seems to love the company's jeans, the firm can focus on developing more stylish jeans and provides special offers for customers. 
* The more customers leave reviews, the more data we have. Thus, we can keep improve the model and even test the model on unlabeled data, such as posts on social media platforms