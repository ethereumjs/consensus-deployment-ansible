# Setting up Digital Ocean Terraform

- Get DO account added by Jamie,et all
- Sign in, configure 2FA
- Copy the `main.tf` file from one of the earlier folders
- Sign in to the DO webpage, get the DO API token: Click on API on the side panel > Create personal access token
- Save this personal access in a password manager or whatever you use. Export it as a variable called `TF_VAR_do_token`,
  terraform will then use this to authenticate with DO. Not recommended, but you can save it as a `tf.vars`(don't commit) file or export
  it in your `.zshrc/.bashrc` for ease of access.
- DO Terraform has a s3 backend that we can use to save terraform state for easy shared access. We can configure this by
  going to the DO webpage > Spaces in the side panel > create new spaces > fill in the required information
- If your project already has a space, then just simply go to API > Spaces access keys > Generate new key. Save this key
  in your password manager.
- Open up your `~/.aws/credentials` file, create a new profile called `[digitalocean]`. Under this profile, configure two
  variables called `aws_access_key_id` and `aws_secret_access_key` with the keyID & access key you obtained in the previous step.
- Now go back to your terraform project folder with the `main.tf` and run `AWS_PROFILE=digitalocean terraform init`, the
  project should initialize.
- Either export `AWS_PROFILE=digitalocean` or append it to each terraform command to use the DO tokens