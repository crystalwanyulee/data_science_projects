# CS114 Spring 2020 Programming Assignment 3
# N-gram Language Models

from collections import defaultdict
from languageModel import LanguageModel
import numpy as np
from scipy.sparse import lil_matrix

class Bigram(LanguageModel):

    def __init__(self):
        # self.word_dict[word] = index
        self.word_dict = {}
        # self.total[previous_word] = count(previous_word)
        self.total = None
        self.prob_counter = None

    '''
    Trains a bigram language model on a training set.
    Specifically, fills in self.prob_counter such that:
    self.prob_counter[previous_word][word] = P(word|previous_word)
    '''
    def train(self, trainingSentences):
        # your code here
        pass

    '''
    Returns the probability of the word at index, according to the model, within
    the specified sentence.
    '''
    def getWordProbability(self, sentence, index):
        return 0

    '''
    Returns, for a given context, a random word, according to the probabilities
    in the model.
    '''
    def generateWord(self, context):
        return 'puppy'
