import urllib
import urllib.request

url = 'url_to_file'
download_path = 'where_to_save_file' # contain filename
filename = 'filename'

def _progress(count, block_size, total_size):
	sys.stdout.write('\r>> Downloading %s %.1f%%' %(
		filename, float(count * block_size) / float(total_size) * 100.0))
	sys.stdout.flush()

urllib.request.urlretrieve(url, download_path, _progress)