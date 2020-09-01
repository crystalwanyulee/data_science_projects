# The Market Shocks of COVID-19







## Introduction

In this project, we would like to look into S&P 500, a stock market index, and see how the coronavirus health crisis has impacted the 11 underlying sectors of the S&P 500 with our main focus on the healthcare industry’s present and future outlook. We first analyzed the percentage change in stock price during the period between February 14 to March 23, and calculated the value retention together with the market cap for each company in S&P 500, in which companies are highly representative of their underlying industry. Based on this information, we then delivered a broad overview of the current situation in the Energy and the Financials sectors. 



<p align="center">	
	<img align="middle" width=550 height=480 src="images/Movements of Average Stock Prices.png">
</p>





<p align="center">	
	<img align="middle" width=650 height=480 src="images/Movements of Average Stock Prices by Sectors.png">
</p>





## Exploratory Analysis

<p align="center">	
	<img align="middle" src="images/The proportion for each sector in sp500.png">
</p>



Value retention discloses how robust a company is in the coronavirus crisis. Cluster analysis can segment these companies based on similar value retention and further examine what kind of companies might have a better ability to stand the severe condition.

#### **Conducting Clustering and Evaluating results**

Here we applied two clustering algorithms, K-means and K-medians and presented the results in **Figure 5**. To avoid any group with very few companies in it, we compared the smallest cluster in two approaches and highlighted them in blue color. K-medians has at least 118 companies in a cluster, which is larger than 116 in K-means, so we decided to adopt the results of K-medians.





#### **Re-labeling Clusters**

To recognize the difference between clusters and re-label them based on value retention, we computed average value retention of each cluster **(Table 1)**. Cluster 1 has the smallest value retention, and thus it is reasonable to regard it as the Low-Value Retention Cluster (LVR). The largest one is Cluster 2, so it is supposed to be the High-Value Retention Cluster (HVR). Because Cluster 3 is in the middle, we can view it as the Medium Value Retention Cluster (MVR).

 

| **K-median  Clusters** | **#  of Companies** | **Weighted  Average VR** | **New  Label** |
| ---------------------- | ------------------- | ------------------------ | -------------- |
| Cluster 1              | 118                 | 42.11                    | LVR            |
| Cluster 2              | 176                 | 74.94                    | HVR            |
| Cluster 3              | 211                 | 59.40                    | MVR            |
| *Table 1.*             |                     |                          |                |

 

#### **Analyzing the Composition of the Clusters**

Now, we want to inspect companies belonging to what kind of sectors in a cluster. For each sector, we computed the number of companies in each cluster and divided it by the total number of companies in a sector (**Table2**).

<p align="center">	
	<img align="middle" src="images/image-20200901150009597.png">
</p>



Subsequently, by visualizing the above results through a parallel coordinate plot (**Figure 6**), we can have a glance at the change of the composition in three clusters. Vertical lines represent three clusters. Each trend line represents a sector, and colors of lines differentiate their trends. Red lines show the downward trends, meaning that most firms in a sector belong to LVR. Blues ones are the increasing lines, indicating that companies of a sector are mostly aligned with HVR. Lastly, the sector is colored in grey if businesses within it are majorly located in MVR.

 <p align="center">	
	<img align="middle" src="images/Percentages of Clsuters in each Sector (all).png">
</p>



In LVR, Energy and Consumer Discretionary have high proportions of companies. We can suggest that these two sectors are susceptible to the Coronavirus crisis. Notably, about 90% of companies in Energy belong to LVR, demonstrating that energy industries are greatly harmed by Coronavirus. This result is consistent with our finding in Question 2.

In MVR, Financials, Utilities, Industrials, and Real Estate become more significant than in the previous cluster. All of them are at the top of MVR. Consumer Discretionary slightly decreases but keeps a certain amount of proportion. However, Energy dramatically goes down and almost disappears. As for blue lines, Health Care and Information Technology and Communication Services start moving up, whereas Consumer Staples stay insignificant.



In HVR, Consumer Staples, Healthcare, Information Technology, and Communication Services far exceed other sectors, implying that these sectors are relatively more robust than other industries. In particular, Consumer Staples considerably rises to about 80%, although the line of it looks flat in the previous two clusters. It points out that Consumer Staples has an excellent capability to overcome this hard time. Additionally, Utilities, Real Estate, and Industrials decline but stay a certain amount of proportion. Yet, Consumer Discretionary and Financials decline close to 0.



**Considering Market Cap to Examine the Change in Clusters**

In the previous plot, we assumed all companies to have the same scale. In fact, different sizes of companies might cause different influences on the industries. Thus, this time we added the market cap factor into our analysis to quantify how large an influence a company can bring. Instead of calculating the number of companies, we summed values of the market cap in each cluster and divided it by the total amount of market cap in a sector. The results are visualized in **Figure 7**.

<p align="center">	
	<img align="middle" src="images/The Distribution of Clusters in Market Values for each Sector (all).png">
</p>



The energy sector still stays in the weak group, but the consumer discretionary sector switches to the strong class. It shows that most corporations in Consumer Discretionary have lower value retention but also have a smaller market cap. Thus, they cause relatively little influence on the market. The finding matches the conclusion in Question 1. Amazon is the biggest company in this industry with a huge market cap, $1063 billion (compared to the second largest one, Home Depot, with $264 billion). Because consumers can gain products through e-commerce, Amazon can continue to make profits and retain 89% values. It successfully mitigates the negative impact of Coronavirus on the consumer discretionary sector. 



In addition, Communication Services here become the top one in HVR. It implies that companies of HVR in Communication Services might be large enough and be able to retain relatively more value in a difficult time as well. Netflix and Verizon are the bigger companies in this industry and retain 94% and 85% of market cap. Obviously, two companies contribute a lot on the market.

In the financial sector, its line looks more symmetric and less steep than the previous one, but most firms in the financial industry remain in MVR. The result is not surprising because we have illustrated there is a trivial difference in the average value retain between companies with higher market cap and lower market cap. 

As for the healthcare sector, companies are primarily in HVR. Only a few of them are classified into MVR and LVR. According to the explanations in Question 4 and 6, we can suggest that healthcare insurance companies might be those retaining fewer values, whereas other companies, such as health technology or pharmaceutical companies might be in the high value retain group.



