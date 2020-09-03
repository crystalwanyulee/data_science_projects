import numpy as np

'''
Tuan Do, Kenneth Lai
'''
class LanguageModel(object) :

    START = "<S>";
    STOP = "</S>";
    UNK = "<UNK>";

    def __init__(self):
        self.word_dict = {}
        self.total = None
        self.prob_counter = None

    '''
    Constructs a language model from a collection of sentences.
    -----
    
    trainingSentences = list of lists of strings (words)
    '''
    def train(self, trainingSentences):
        pass

    '''
    Returns the probability, according to the model, of the word specified
      by the argument sentence and index. Index ranges from 0 to len(sentence),
      inclusive. If index==len(sentence), return P(STOP | context).
      
    -----
    sentence: list of strings (words)
    index: index to calculate the probablity
    '''
    def getWordProbability(self, sentence, index):
        pass


    '''
    Returns the set of tokens the model makes predictions for. This
    includes STOP and UNK, but not START (because we do not need to
    compute P(START | context)).

    -----
    Return: list of strings
    '''
    def getVocabulary(self):
        return list(self.word_dict)

    '''
    Returns a random word sampled according to the model.
    
    -----
    Return: string
    '''
    def generateWord(self):
        pass

    '''
    Returns a random sentence sampled according to the model.
    
    -----
    Return: list of strings
    '''
    def generateSentence(self):
        result = []
        # limit sentence length to 20
        for i in range(20):
            word = LanguageModel.UNK
            while word == LanguageModel.UNK:
                # make sure word != UNK
                word = self.generateWord(result)
            if word == LanguageModel.STOP:
                break
            result.append(word)
        return result

    #-----------------------------------------------------------------------

    '''
    Returns the probability, according to the model, of the specified
    sentence.  This is the product of the probabilities of each word in
    the sentence (including a final stop token).
    
    -----
    sentence: list of strings
    '''
    def getSentenceLogProbability(self, sentence) :
        logProbability = sum( np.log2(self.getWordProbability(sentence, i)) for i in range(len(sentence) + 1)) 
        return logProbability
    

    '''
    Given a list of words, sums over the probabilities of every token that
    could follow. If the model implements a valid probability
    distribution, this should always sum to 1.
    '''
    def checkProbability(self, context):
        modelsum = 0.0;
        for token in self.getVocabulary():
            context.append(token)
            modelsum += self.getWordProbability(context, len(context) - 1)
            del context[-1]

        return modelsum
