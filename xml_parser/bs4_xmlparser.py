import requests, bs4, lxml

def PrintParseTree(tree):
	job_lists = tree.select('result')
	return_list = []
	for job in job_lists:
		job_object = {}
		for job_field in job:
			job_value = job_field
			job_object[job_field.name] = job_field.getText()
		return_list.append(job_object)
	return return_list

res = requests.get('http://api.indeed.com/ads/apisearch?publisher=488027196709698&l=los%2Cangeles%2C+ca&sort=&radius=&st=&jt=&start=&limit=&fromage=&filter=&latlong=1&co=us&chnl=&userip=1.2.3.4&useragent=Mozilla/%2F4.0%28Firefox%29&v=2')
soup = bs4.BeautifulSoup(res.text, 'xml')
print PrintParseTree(soup)
