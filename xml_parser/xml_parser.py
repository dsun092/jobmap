from bs4 import BeautifulSoup as BS
from xml_fetcher import XML_Fetcher
import json

class XML_Parser(object):
	""" Class created to parse XML file from a url and return list of dictionaries

	Dictionary key will be the tag of XML and the value will be the text string within tags """

	def __init__(self, url, parent_tag, descendant_tags):
		""" Args: parent_tag expects a string and the parent tag of the tag you want to scrape

		descendant_tags is a list of descendant tags you want to scrape from

		url represents the url of the XML webpage you want to scrape

		"""

		self.descendant_tags = descendant_tags
		self.parent_tag = parent_tag
		self.url = url

	def parse_xml_file(self):
		""" Fetches XML text from XML_Fetcher helper class and parses for text in tags """

		xml_text = XML_Fetcher.get_xml(self.url)
		parsed_XML = BS(xml_text, 'xml')

		descendant_tag_to_string_list_of_dicts = []
		""" Empty list of dictionaries
		Each index will store the tag : tag_text that you wish to parse """

		parent_XML_list = parsed_XML.select(self.parent_tag)
		# List of blocks of XML under parent tag

		for xml_block in parent_XML_list:

			for xml_line in xml_block:
				if xml_line.name in self.descendant_tags:
					desc_dict = {}
					desc_dict[xml_line.name] = xml_line.getText()
					descendant_tag_to_string_list_of_dicts.append(desc_dict)


		print(descendant_tag_to_string_list_of_dicts)

url = 'http://api.indeed.com/ads/apisearch?publisher=488027196709698&q=&l=los%2Cangeles%2C+ca&sort=&radius=&st=&jt=&v=2&userip=1.2.3.4&start='
parent_tag = 'result'
desc_tag = ['longitude', 'latitude', 'jobtitle', 'company', 'state', 'city']
parser = XML_Parser(url, parent_tag, desc_tag)
parser.parse_xml_file()


