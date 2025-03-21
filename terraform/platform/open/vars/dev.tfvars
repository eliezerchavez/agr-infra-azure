platform="gaip"

net = {
  snet = {
    address_prefix = "10.130.179.64/27"
  }
  rt = {
    routes = {
      default = {
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.130.96.100"
      }
      to-commonservices-vnet = {
        address_prefix         = "10.130.96.0/25"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.130.96.100"
      }
    }
  }
}
