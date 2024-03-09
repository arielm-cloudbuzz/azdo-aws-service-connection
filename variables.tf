variable "iam_user" {
  type = object(
    {
      name                 = string
      path                 = optional(string)
      permissions_boundary = optional(string)
      force_destroy        = optional(bool)
      tags                 = optional(map(string))
    }
  )
  default = null
}

variable "iam_role" {
  type = object(
    {
      name                 = string
      path                 = optional(string)
      permissions_boundary = optional(string)
      assume_role_policy   = optional(string)
      description          = optional(string)
      max_session_duration = optional(number)
      tags                 = optional(map(string))
    }
  )
  default = null
}

variable "env" {
  default = null
}
