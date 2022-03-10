# 問題 1 - コンテナ mariadb

# 問題

mariadbのコンテナが立ち上がらない。

## 初期状態

- VM上で `sudo docker ps -a` すると、一つだけコンテナ `mariaDB` が存在している
- VM上で `sudo docker start mariaDB` を行って、 `sudo docker exec -it mariaDB bash` をしてshellに入ろうとしても入れない

## 完了要件

- コンテナが継続して起動し続けている状態にする
- `sudo docker exec -it mariaDB bash` でコンテナの中に入ることができる。
- コンテナに入ってMariaDBに接続して DB `chall` のテーブル `container_mariadb` をみた時、以下のようにデータが表示される。

```
+----+------------+-----------+-----+-------+
| ID | First_Name | Last_Name | Age | Sex   |
+----+------------+-----------+-----+-------+
|  1 | Tarou      | Yamada    |  23 | MAN   |
|  2 | Emi        | Uchiyama  |  23 | WOMAN |
|  3 | Ryo        | Sato      |  25 | MAN   |
|  4 | Yuki       | Tayama    |  22 | WOMAN |
|  5 | Yuto       | Takahashi |  21 | MAN   |
+----+------------+-----------+-----+-------+
```

- 3306番ポートが空いている

# 再現手順

使い捨て可能な、Linux環境(Ubuntu20.04)をVMで新しく用意し、以下のコマンドを実行。

```sh
# install ansible
sudo apt update && sudo apt install -y software-properties-common && sudo apt-add-repository -y --update ppa:ansible/ansible && sudo apt install -y ansible git
# repositoryを取ってくる
git clone https://github.com/uta8a/learn-infra.code.git
cd learn-infra.code/container-mariadb/provisioning
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

以下の資料を参考に作成しています。

- [Status code 418sの勉強会資料](https://hunachi.github.io/ictsc-418/kakomon/2019-honsen/container.html)
- [ICTSC - 生き返れMariaDB](https://blog.icttoracon.net/2020/03/01/%E7%94%9F%E3%81%8D%E8%BF%94%E3%82%8Cmariadb/)
