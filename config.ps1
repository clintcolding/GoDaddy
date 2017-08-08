$Provider = @{

    Comcast = @{                # Your ISP
        Services = @{
            blog = '10.1.2.3'   # Your record name and IP
            "@"  = '10.1.2.4'   # Your record name and IP
        }
    }

    Level3 = @{                 # Your other ISP
        Services = @{
            blog = '20.2.3.4'   # Your record name and IP
            "@"  = '20.2.3.5'   # Your record name and IP
        }
    }
}