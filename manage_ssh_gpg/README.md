## Managing SSH and GPG keys

## Setup
- Check if exists
```
$ ls -al ~/.ssh
```

### Generating SSH Keys
- RSA
```
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
- Edwards
```
$ ssh-keygen -t ed25519 -C "your_email@example.com"
```

- Start the ssh-agent in the background.
```
$ eval "$(ssh-agent -s)"
> Agent pid 59566
$ ssh-add ~/.ssh/id_ed25519
```

- Configure identity
```
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

Go to your users settings on Github to add public key on your account.

Menu -> Settings -> SSH and GPG Keys -> New SSH Key

Put the content of public key.

### Permissions
- Recommended
```
chmod  400 ~/.ssh/id_ed25519
```
