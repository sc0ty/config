import sys

ftopts = {
  'cpp': [
    '-x', 'c++',
    '-std=gnu++11',
  ],
  'c': [
    '-std=gnu99',
    '-x', 'c',
    '-I', '.',
  ],
  'objc': [
    '-x', 'objective-c',
    '-I', '.',
  ],
}

def FlagsForFile(filename, **kwargs):
  client_data = kwargs['client_data']
  ft = client_data['&filetype']

  try:
    opts = ftopts[ft]
  except:
    opts = ftopts['cpp']

  if client_data and 'throw' in client_data:
    raise ValueError( client_data['throw'] )

  return {
    'flags': opts,
    'do_cache': True
  }
