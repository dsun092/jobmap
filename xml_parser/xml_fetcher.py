import requests

class XML_Fetcher(object):
	""" Helper Class created to fetch markup for XML_Parser """

	@classmethod
	def get_xml(cls, url):
		""" Retrieve XML document

		Args: url is any URL you want to retrieve the XML from

		Returns string of the XML file """

		markup = requests.get(url).text
		return markup