#!/usr/bin/env python
# -*- coding: gbk -*-
# ==============================================================================
#          \file   text2ids.py
#        \author   chenghuige  
#          \date   2016-08-29 15:26:15.418566
#   \Description  
# ==============================================================================

  
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import tensorflow as tf
import numpy as np

import sys
import gezi

from deepiu.util import vocabulary 
#TODO-- remove conf.py using gfalgs or yaxml

try:
  import conf
  from conf import TEXT_MAX_WORDS, ENCODE_UNK
except Exception:
  print('Warning: no conf.py in current path use util conf')
  from deepiu.util.conf import TEXT_MAX_WORDS, ENCODE_UNK

vocab = None 
Segmentor = None 

NUM_MARK = '<NUM>'

def init(vocab_path=None):
  global vocab, Segmentor
  if vocab is None:
    vocabulary.init(vocab_path)
    print('ENCODE_UNK', ENCODE_UNK, file=sys.stderr)
    vocab = vocabulary.get_vocab()
    Segmentor = gezi.Segmentor()

#@TODO gen-records should use text2ids
#TODO ENCODE_UNK might not be in conf.py but to pass as param encode_unk=False
def words2ids(words, feed_single=True, allow_all_zero=False, 
              pad=True, append_start=False, append_end=False,
              max_words=None, norm_digit=True, norm_all_digit=False):
  """
  default params is suitable for bow
  for sequence method may need seg_method prhase and feed_single=True,
  @TODO feed_single is for simplicity, the best strategy may be try to use one level lower words
  like new-word -> phrase -> basic -> single cn

  #@TODO feed_single move to Segmentor.py to add support for seg with vocab 
  norm_all_digit is not used mostly, since you can control this behavior when gen vocab 
  """
  if not feed_single:
    word_ids = [vocab.id(word) for word in words if vocab.has(word) or ENCODE_UNK]
  else:
    word_ids = []
    for word in words:
      if norm_all_digit and word.isdigit():
        word_ids.append(vocab.id(NUM_MARK))
        continue
      if vocab.has(word):
        word_ids.append(vocab.id(word))
      elif not norm_all_digit and norm_digit and word.isdigit():
        word_ids.append(vocab.id(NUM_MARK))
      else:
        cns = gezi.get_single_cns(word)
        if cns:
          for w in gezi.get_single_cns(word):
            if vocab.has(w) or ENCODE_UNK:
              word_ids.append(vocab.id(w))
        else:
          if ENCODE_UNK:
            word_ids.append(vocab.unk_id())

  if append_start:
    word_ids = [vocab.start_id()] + word_ids

  if append_end:
    word_ids = word_ids + [vocab.end_id()]

  if not allow_all_zero and  not word_ids:
    word_ids.append(vocab.end_id())

  if pad:
    word_ids = gezi.pad(word_ids, max_words or TEXT_MAX_WORDS, 0)  

  return word_ids

def text2ids(text, seg_method='basic', feed_single=True, allow_all_zero=False, 
            pad=True, append_start=False, append_end=False, to_lower=True,
            max_words=None, norm_digit=True, norm_all_digit=False):
  """
  default params is suitable for bow
  for sequence method may need seg_method prhase and feed_single=True,
  @TODO feed_single is for simplicity, the best strategy may be try to use one level lower words
  like new-word -> phrase -> basic -> single cn

  #@TODO feed_single move to Segmentor.py to add support for seg with vocab 
  """
  if to_lower:
    text = text.lower()
  words = Segmentor.Segment(text, seg_method)
  return words2ids(words, 
                   feed_single=feed_single, 
                   allow_all_zero=allow_all_zero, 
                   pad=pad, 
                   append_start=append_start, 
                   append_end=append_end, 
                   max_words=max_words, 
                   norm_digit=norm_digit,
                   norm_all_digit=norm_all_digit)

def ids2words(text_ids, print_end=True):
  #print('@@@@@@@@@@text_ids', text_ids)
  #NOTICE int64 will be ok
#  Boost.Python.ArgumentError: Python argument types in
#    Identifer.key(Vocabulary, numpy.int32)
#did not match C++ signature:
#    key(gezi::Identifer {lvalue}, int id, std::string defualtKey)
#    key(gezi::Identifer {lvalue}, int id)
  #words = [vocab.key(int(id)) for id in text_ids if id > 0 and id < vocab.size()]
  words = []
  for id in text_ids:
    if id > 0 and id < vocab.size():
      #@NOTICE! must has end id, @TODO deal with UNK word
      if id != vocab.end_id():
        word = vocab.key(int(id))
        words.append(word)
      else:
        if print_end:
          words.append('</S>')
        break
    else:
      break
  return words

def ids2text(text_ids, sep='/'):
  return sep.join(ids2words(text_ids))

def idslist2texts(text_ids_list, sep='/'):
  return [ids2text(text_ids) for text_ids in text_ids_list]
  #return [sep.join([vocab.key(int(id)) for id in text_ids if id > 0 and id < vocab.size()]) for text_ids in text_ids_list]


def text2segtext(text, seg_method='default', feed_single=False, allow_all_zero=False, pad=True, sep='/'):
  return ids2text(text2ids(text, seg_method=seg_method, feed_single=feed_single, allow_all_zero=allow_all_zero))

def texts2segtexts(texts, seg_method='default', feed_single=False, allow_all_zero=False, pad=True, sep='/'):
  return idslist2texts(texts2ids(texts,seg_method=seg_method, feed_single=feed_single, allow_all_zero=allow_all_zero))

def segment(text, seg_method='default'):
  return Segmentor.Segment(text, seg_method=seg_method)

def texts2ids(texts, seg_method='default', feed_single=False, allow_all_zero=False, pad=True):
  return np.array([text2ids(text, seg_method, feed_single, allow_all_zero, pad) for text in texts])

def start_id():
  return vocab.end_id()

def end_id():
  return vocab.end_id()

def unk_id():
  return vocab.unk_id()
