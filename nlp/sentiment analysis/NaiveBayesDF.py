import os
import numpy as np
from collections import defaultdict
import pandas as pd
import random

os.chdir('C://Users/wanyu/Documents/Computational Linguilistics/PA2/github')


class NaiveBayes():

    def __init__(self, train_df, test_df):
        
        self.train_df = train_df
        self.test_df = test_df
        self.train_data = {}
        self.class_dict = {}
        self.feature_dict = {}
        self.V = {}
        self.V_unique = []
        self.class_count = []
        self.word_count = []
        self.feature_ratio = None
        self.prior = None
        self.likelihood = None
        self.label_col = None
        self.text_col = None
        
  
    
    def preprocess_text(self, text):
        """
        Transform text data into a series of token words
        """
        # Remove new lines and concatenate each line into a string 
        text = ''.join(text.splitlines())
        # Transform a document into a series of token words
        text = text.split(' ')
        # Remove noncharacters
        text = [str(i).lower() for i in text if i.isalpha()]
        
        return text



    def get_train_data(self, label_col, text_col, class_dict=None):
        
        """
        Stores all documents and words as class instances
        Compute the number of documents in each class,
        And the number of words in each document simultaneously
        """
        
        self.label_col = label_col
        self.text_col = text_col
        
        self.class_dict = class_dict
        
        if class_dict == None:
            self.class_dict = {c_index: word 
                               for c_index, word 
                               in enumerate(self.train_df[self.label_col].unique())}
            
        
        for c_index, c_name in self.class_dict.items():
            document_list = []
            word_list = []
            
            for document in self.train_df.loc[self.train_df[self.label_col] == c_name, self.text_col]:
                document = self.preprocess_text(document)
                document_list.append(document)
                word_list.extend(document)
            
            self.train_data[c_index] = document_list            
            self.V[c_index] = word_list 
            # Compute the number of documents in each class
            self.class_count.append(len(document_list))
            # Compute the number of words in each class
            self.word_count.append(len(word_list))
        
        self.class_count = np.matrix(self.class_count).reshape(len(self.class_dict),1)
        self.word_count = np.matrix(self.word_count).reshape(len(self.class_dict),1)    
 
    
    
    def potential_features(self, freq=0.0002, num_f=50):
        """
        Selects some potential features that might be useful to classify
        based on the likelihood ratio:
            LR(w) = max (P(w|c1) / P(w|c2), P(w|c2) / P(w|c1))    
        """
        
        # Calculate a frequency for each word and each class
        for key, value in self.V.items():
            self.V[key] = pd.Series(value).value_counts()
            
        # Combine two Series based on word indices
        df = pd.DataFrame(self.V).fillna(1)
        word_index = np.array(df.index)
        mat = np.matrix(df)
        
        # Calculate conditional probabilites for each word
        mat = np.divide(mat, mat.sum(axis=0))
        
        # Choose words with higher frequencies and stores their position
        # We can set a frequency rate in the function. The default is 0.0002.
        h_freq = np.where(np.sum(mat > freq, axis=1) != 0)[0]
        
        # Compute the likelihodd ratio
        
        ratio_name = []
  
        LR = np.zeros((mat.shape[0],1))
        for i in range(mat.shape[1]):
            for j in range(mat.shape[1]):
                if i == j: continue
                LR = np.c_[LR, mat[:,i]/mat[:,j]]
                name = self.class_dict[i] + '_' + self.class_dict[j]
                ratio_name.append(name)
        
        # Choose words based on the values of LR
        # We can set the number of candidates in our function.
        # The default is 50.
        
        top_LR_index = LR[h_freq].max(axis=1).argsort(axis=0)[:-(num_f+1):-1]
        candidate = word_index[h_freq][top_LR_index].reshape(1,num_f).tolist()

        column_name = list(self.class_dict.values()) + ratio_name        
        self.feature_ratio = pd.DataFrame(np.c_[mat,LR[:, 1:]], 
                                          columns = column_name,
                                          index = word_index)
        
        return candidate[0]
    

    def get_key(self, my_dict, val): 
        """
        Get the key by value in dictionary.
        """
        for key, value in my_dict.items(): 
            if val == value: 
                return key 


    def get_feature_dict(self, feature_list):
        
        feature_dict = { i: feature_list[i] 
                        for i in range(len(feature_list))}   
        
        return feature_dict


    def train(self, feature_list):
        """
        Trains a multinomial Naive Bayes classifier on a training set.
        Specifically, fills in self.prior and self.likelihood such that:
        self.prior[class] = log(P(class))
        self.likelihood[class][feature] = log(P(feature|class))
        """
        # Define the features dictionary to train
        self.feature_dict = self.get_feature_dict(feature_list)
        
        # Compute the number of features in each document
        features_count = np.ones((len(self.class_dict), 
                                  len(self.feature_dict)))
        

        for class_idx, class_docs in self.train_data.items():
            for document in class_docs:
                for word in document:
                    if word in self.feature_dict.values():
                        feature_index = self.get_key(self.feature_dict, word)
                        features_count[class_idx][feature_index] += 1

        # Get unique words in all documents
        if self.V_unique == []:
            for w_df in self.V.values():
                word_list = list(w_df.index)
                self.V_unique.extend(word_list)
                #print(type(w_list))
            self.V_unique = list(set(self.V_unique))
        

        # normalize counts to probabilities, and take logs
        self.prior = np.log(self.class_count/np.sum(self.class_count))
        self.likelihood = np.log(np.divide(features_count, self.word_count+len(self.V_unique)))


    def test(self, data=0):
        """
        Tests the classifier on a development or test set.
        Returns a dictionary of filenames mapped to their correct 
        and predicted classes such that:
        results[fileID]['correct'] = correct class
        results[fileID]['predicted'] = predicted class
        """
        
        results = defaultdict(dict)
        
        if data == 0:
            data = self.test_df
            

        for c_index, c_name in self.class_dict.items():
            
            for document in data.loc[data[self.label_col] == c_name, self.text_col]:
                document = self.preprocess_text(document)
                feature_count = np.zeros((len(self.feature_dict), 1))
                
                for word in document:
                    if word in self.feature_dict.values():
                        feature_index = list(self.feature_dict.values()).index(word)
                        feature_count[feature_index] += 1
                         
                class_prob = self.prior + self.likelihood.dot(feature_count)
                class_pred = int(class_prob.argmax(axis=0))
                results[len(results)]= {'correct': c_index,
                                        'predicted': class_pred}
        
        return results


    def confusion_matrix(self, results):
        """
        Compute a confusion matrix based on results produced from test()
        """
        confusion_matrix = np.zeros((len(self.class_dict),
                                     len(self.class_dict)))
        
        for doc in results.values():
            confusion_matrix[doc['correct'], doc['predicted']] +=1
        
        return confusion_matrix    
    
    
    def evaluate(self, results):
       """
       Given results, calculates the following metrics:
       Precision, Recall, F1 for each class, and overall Accuracy
       Return an evaluation metrics in a DataFrame format.
       """
       
       confusion_matrix = self.confusion_matrix(results)
       
       indicator = pd.Series(['Class', 'Accuracy', 'Precision', 
                              'Recall', 'F1'])
       
       performance = []
        
       for i in range(2):
           class_name = self.class_dict[i]
           accuracy = round(np.sum(confusion_matrix.diagonal()) / np.sum(confusion_matrix), 3)
           precision = round(confusion_matrix[i,i] / np.sum(confusion_matrix[:,i]), 3)
           recall = round(confusion_matrix[i,i] / np.sum(confusion_matrix[i]), 3)
           f1_score = round((2*precision*recall) / (precision+recall), 3)
           performance.append([class_name, accuracy, precision, recall, f1_score])
       
       performance = pd.DataFrame(np.array(performance), columns=indicator).set_index('Class')

       return performance




    def select_features(self, feature_list, method = 'forward', 
                        random_select = True, max_features = 10, 
                        min_features = 10, metric = 'Accuracy', 
                        class_index = 0, show_process = False, 
                        print_mode = True):
        
        """
        Performs a process of feature selection
        Returns a set of features and evaluation with the best performance
        
        Here, there are two methods used for selecting features:
         - Forward Method: 
             Begins with an empty model and adds in one feature at each step.
             If the performance is better, then keep it. Otherwise, drop it.
        
         - Backward Method:
             Begins with all the features selected and removes one feature 
             at each step. If the performance is better, then keep it. 
             Otherwise, drop it.
        
        """
        # Initialize 
        final_features = []
        best_metric = 0
        best_evaluation = None
        
        # Shuffle features and make them have a random order
        if random_select:
            random_indices = random.sample(range(len(feature_list)-1), 
                                           len(feature_list)-1)
            feature_list = [feature_list[i] for i in random_indices]
        
        # Forward Method
        if method == 'forward':
            for feature in feature_list:
                # Add one feature at each step
                final_features.append(feature)
                # Training model and compute some performance metrics 
                self.train(final_features)
                results = self.test()
                evaluation = self.evaluate(results) 
                
                # Set a metric to evaluate performance
                metric_v = float(evaluation.loc[self.class_dict[class_index], metric])
                
                # Determine if we should drop the feature based on the metric
                if metric_v > best_metric:
                    best_metric = metric_v
                    best_evaluation = evaluation
                    
                else:
                    final_features.remove(feature)
                
                # Show the selection process and print results at each round
                # The default is True
                if show_process == True:
                    print(best_metric)
                    print(final_features)
                
                # If the number of features achieve the maximum number,
                # then the selection process will stop
                # The default is at most 10 features
                if len(final_features) == max_features:
                    break
        
        # Backward Method
        elif method == 'backward':
            
            # Begin with all the features selected
            final_features = feature_list
            
            # Remove one feature at each step
            for i in range(len(feature_list)): 
                if i != 0:
                    # Select the first one feature as a test word 
                    test_word = final_features[0]
                    # Remove the test word
                    final_features.remove(test_word)
                
                # Training model and compute some performance metrics 
                self.train(final_features)
                results = self.test()
                evaluation = self.evaluate(results)  
                
                # Determine if we should drop the feature 
                # based on the metric we define in the function
                metric_v = float(evaluation.loc[self.class_dict[class_index], metric])
                
                
                if metric_v >= best_metric:
                    best_metric = metric_v
                    best_evaluation = evaluation
                    
                else:
                    final_features.append(test_word)
                
                # Determine if we need to print results at each round
                # The default is True               
                if show_process == True:
                    print(best_metric)
                    print(final_features)
                
                # If the number of features achieve the minimum number,
                # then the selection process will stop
                # The default is at least 10 features
                if len(final_features) == min_features:
                    break
        
        # Save the best model through training again
        self.train(final_features)
        results = self.test()
        evaluation = self.evaluate(results)  

        
        # Decide whether the program print results or not. 
        # The default is True
        if print_mode:
            print('------- The Number of Final Features -------\n')
            print(str(len(final_features)) + '\n')
            print('------- Features with the Best Performance -------\n')
            print(', '.join(final_features) + '\n')
            print('------- The Best Performance of the Model -------\n')
            print(best_evaluation)     
        
        
        return final_features, best_evaluation
    
