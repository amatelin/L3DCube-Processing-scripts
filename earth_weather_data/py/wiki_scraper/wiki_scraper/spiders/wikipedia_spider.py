# -*- coding: utf-8 -*-

import scrapy

from wiki_scraper.items import WikiScraperItem

class WikipediaSpider(scrapy.Spider):
    name = "wikipedia_cities"
    allowed_domains = ["en.wikipedia.org", "tools.wmflabs.org"]
    start_urls = ["https://en.wikipedia.org/wiki/List_of_national_capitals_in_alphabetical_order"]
    
    def parse(self, response):
        for href in response.xpath('//table[2]/tr/td[1]/a/@href'):
            url = response.urljoin(href.extract())
            yield scrapy.Request(url, callback=self.parse_city)
            
        
    def parse_city(self, response):
        url = "https://" + response.xpath("//*[@class='latitude']/../../../@href").extract_first()[2:]
        print(url)        
        yield scrapy.Request(url, callback=self.parse_coord)
        
    def parse_coord(self, response):
        print("AAAAAAAA")
        print(response.xpath("//*[@id='firstHeading']/text()").extract_first())
        item = WikiScraperItem()
        
        
        item["name"] = response.xpath("//*[@id='firstHeading']/text()").extract_first()[10:]
        item["lat"] = response.xpath("//span[@class='latitude']/text()").extract_first()
        item["long"] = response.xpath("//span[@class='longitude']/text()").extract_first()
        
        yield item