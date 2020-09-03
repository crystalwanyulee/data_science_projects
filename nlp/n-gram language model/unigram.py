from collections import defaultdict
from languageModel import LanguageModel
import numpy as np
from scipy.sparse import lil_matrix

'''
Tuan Do, Kenneth Lai
'''
class Unigram(LanguageModel):

    def __init__(self):
        self.word_dict = {}
        self.total = None
        self.prob_counter = None

    '''
    Trains a unigram language model on a training set.
    Specifically, fills in self.prob_counter such that:
    self.prob_counter[word] = P(word)
    '''
    def train(self, trainingSentences):
        word_counts = defaultdict(int)
        # iterate over training sentences
        for sentence in trainingSentences:
            for word in sentence:
                word_counts[word] += 1
            word_counts[LanguageModel.STOP] += 1
        word_counts[LanguageModel.UNK] += 1

        self.prob_counter = lil_matrix((1, len(word_counts)))
        # sort words alphabetically
        for i, word in enumerate(sorted(word_counts)):
            self.word_dict[word] = i
            self.prob_counter[0, i] = word_counts[word]
        # normalize counts to probabilities
        self.total = self.prob_counter.sum()
        # to keep matrix sparse, use multiplication instead of division
        # also convert matrix back to lil format
        self.prob_counter = self.prob_counter.multiply(1 / self.total).tolil()

    '''
    Returns the probability of the word at index, according to the model, within
    the specified sentence.
    '''
    def getWordProbability(self, sentence, index):
        if index == len(sentence):
            word = LanguageModel.STOP
        else:
            word = sentence[index]
            if word not in self.word_dict:
                word = LanguageModel.UNK
        return self.prob_counter[0, self.word_dict[word]]

    '''
    Returns, for a given context, a random word, according to the probabilities
    in the model.
    '''
    def generateWord(self, context):
        # convert matrix to array and flatten
        probs = self.prob_counter[0].toarray().ravel()
        return np.random.choice(sorted(self.word_dict), p=probs)
