variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}

# Choose an Availability Domain
variable "AD" { default = "1" }

variable "InstanceShape" {
  default = "VM.Standard1.1"
}

variable "InstanceImageOCID" {
    type = "map"
    default = {
        // Oracle-provided image "Oracle-Linux-7.4-2017.12.18-0"
        // See https://docs.us-phoenix-1.oraclecloud.com/Content/Resources/Assets/OracleProvidedImageOCIDs.pdf
        us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaasc56hnpnx7swoyd2fw5gyvbn3kcdmqc2guiiuvnztl2erth62xnq"
        us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaaxrqeombwty6jyqgk3fraczdd63bv66xgfsqka4ktr7c57awr3p5a"
        eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaayxmzu6n5hsntq4wlffpb4h6qh6z3uskpbm5v3v4egqlqvwicfbyq"
    }
}
variable "vcn-1_cdir" {
  default = "172.30.0.0/16" // size in GBs
}
variable "vcn-1_name" {
  default = "acme"
}
variable "WebPubSubnetAD1_cdir" {
  default = "172.30.110.0/24"
}
variable "WebDMZSubnetAD1_cdir" {
  default = "172.30.120.0/24"
}
variable "DBPrivSubnetAD3_cdir" {
  default = "172.30.10.0/24"
}
variable "NATDBLan_addr" {
  default = "172.30.10.240"
}
variable "NatPubSubnetAD3_cdir" {
  default = "172.30.140.0/24"
}
variable "WebPubSubnetAD1_name" {
  default = "WebPubSubnetAD1"
}
variable "WebDMZSubnetAD1_name" {
  default = "WebDMZSubnetAD1" // size in GBs
}
variable "DBPrivSubnetAD3_name" {
  default = "DBPrivSubnetAD3"
}
variable "NatPubSubnetAD3_name" {
  default = "NatPubSubnetAD3"
}
variable "DBSize" {
  default = "50" // size in GBs
}

variable "SecondaryVnicCount" {
      default = 1
  }
