variable "region"{
    type = string
}

variable "db_secret_name"{
    type = string
}

variable "master_usr"{
    type = string
}

variable "master_pwd"{
    type = string
}

variable "app_name"{
    type = string
}

variable "env"{
    type = string
}

variable "subnet_ids"{
    type = list(string)
}

variable "vpc_id"{
    type = string
}

variable "mq_security_group_id"{
    type = string
}

variable "app_ci"{
    type = string
}

variable "sla_level"{
    type = string
}

variable "risk_data_class"{
    type = string
}

variable "app_contact_dl"{
    type = string
}

variable "internal_external"{
    type = string
}

variable "regulatory_controls"{
    type = string
}

variable "port"{
    type = number
}
variable "db_cluster_parameter_group_family"{
    type = string
}

variable "db_parameter_group_family"{
    type = string
}

variable "engine"{
    type = string
}

variable "engine_version"{
    type = string
}

variable "instance_class"{
    type = string
}

variable "availability_zones"{
    type = list(string)
}
