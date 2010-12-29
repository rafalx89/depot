xml.product_list() do
        for p in @products
                xml.product do
                        xml.title(p.title)
                        xml.description(p.description)
                        xml.image_url(p.image_url)
                        xml.price(p.price)
                end
        end
end
