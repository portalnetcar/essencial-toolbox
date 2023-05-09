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