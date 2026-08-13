include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/priced"
}

inputs = {
  suffix        = "tg-mixed-priced"
  instance_type = "t3.micro"
}
