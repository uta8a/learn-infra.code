# 問題 2 - docker network

# 問題

コンテナ内部からインターネットに繋がらない。設定を間違えてしまったようだ。

## 初期状態

- VM上で、 `sudo docker ps -a` すると、一つだけコンテナ `easy-net` が存在している
- VM上で、`sudo docker exec easy-net ping -c 3 example.com` としても、 `ping: bad address 'example.com'` と言われてしまい、インターネットに繋がらない。

## 完了要件

- VM上で、`sudo docker exec easy-net ping -c 3 example.com` とした時に、以下のようなReplyが返ってくる

```none
PING archlinux.jp (x.x.x.x): 56 data bytes
64 bytes from x.x.x.x: seq=0 ttl=50 time=y ms
```

# 再現手順


使い捨て可能な、Linux環境(Ubuntu20.04)をVMで新しく用意し、以下のコマンドを実行。

```sh
# install ansible
sudo apt update && sudo apt install -y software-properties-common && sudo apt-add-repository -y --update ppa:ansible/ansible && sudo apt install -y ansible git
# repositoryを取ってくる
git clone https://github.com/uta8a/learn-infra.code.git
cd learn-infra.code/network-easy-1/provisioning
# run ansible
# sudoパスワードなし環境では `-K` はなくて良い場合もある
ansible-playbook main.yml -K
# 問題環境が完成
```

## 補足

以下の環境で動作確認しています。

```none
Host: Ubuntu 20.04
VM: Ubuntu 20.04
$ multipass launch --name chall-1 --cpus 4 --mem 4G --disk 30G lts
```

# トラブルが起きたら

DiscussionまたはIssueに連絡ください。

# 参考にした資料

- [Docker公式の記事](https://docs.docker.com/network/none/)
