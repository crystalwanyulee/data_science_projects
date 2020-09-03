import os

'''
Represents a Jumble text problem.  Each problem has a correct sentence, 
and a list of jumbled sentences. <p/>

The main purpose of this class is the enclosed Reader class, which
provides a front end to a directory full of Jumble data. <p/>

@author Tuan Do
'''
class JumbleProblem (object):
    
    '''
    -----
    correctSentence:  [string]
    nBestSentences:  [[string]]
    '''
    def __init__(self, correctSentence, nBestSentences):
        self.correctSentence = correctSentence
        self.nBestSentences = nBestSentences
        self.VERBOSE = 0

    '''
    return: [string]: the original correct ordering of the sentence.
    '''
    def getCorrectSentence(self):
        return self.correctSentence
    

    '''
    return: [[string]]: the list of jumbled sentences
    '''
    def getNBestSentences(self) :
        return self.nBestSentences
    

    # =======================================================================
    '''
    -----
    path: string
    return:  [JumbleProblem]
    '''
    @staticmethod
    def readJumbleProblems ( path ):
        jumbleProblems = []
    
        with open( os.path.join( path, "gold" )) as fh:
            lines = fh.readlines()
            correctSentences = [line.split() for line in lines]
        
        for i in range(len(correctSentences)):
            f = "test" + str(i)
            with open( os.path.join( path, f )) as fh:
                lines = fh.readlines()
                jumbledSentences = [line.split() for line in lines]
            
            jumbleProblem = JumbleProblem( correctSentences[i], jumbledSentences)
            jumbleProblems.append(jumbleProblem)
        return jumbleProblems
