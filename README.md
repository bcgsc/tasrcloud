# TASRCloud

TASRCloud means Targeted ASsembly on the Cloud.

## Google Cloud Platform (GCP)


### Install the Google Cloud SDK

Follow instructions on [https://cloud.google.com/sdk/](https://cloud.google.com/sdk/)

### Login to GCP in the terminal

    gcloud login

### [Google Cloud Strage](https://cloud.google.com/storage/docs/overview) (GCS)

* [List](https://cloud.google.com/storage/docs/gsutil/commands/ls) a bucket

        gsutil ls gs://my-bucket/path/to/some/dir

* [Renaming](https://cloud.google.com/storage/docs/gsutil/commands/mv) a file

        gsutil mv gs://my-bucket/dir1/file.txt \
                  gs://another-bucket/dir2/anothername.txt

<!-- Whether there is an indent before localhost makes a difference in github
rendering -->
* [Copy](https://cloud.google.com/storage/docs/gsutil/commands/cp) files below
localhost and GCS bucket

        # GCS to local (-r means recursively)
        gsutil -m cp -r gs://gs://my-bucket/dir1 .
        # local to GCS
        gsutil -m cp local_file.txt gs://gs://my-bucket/remote-dir/

* [Sync](https://cloud.google.com/storage/docs/gsutil/commands/rsync)
directories between localhost and GCS bucket

        # -n means dry-run, handy for testing
        # -R & -r are synonymous, means synchronising recursively
        # argument to -x should be a regular expression used to match the full
        # path of files inthe bucket
        gsutil rsync \
            -n -R \
            -x '.*\.log$|.*\.html|.*pass2.*' \
            gs://ccle-results .

### [Google Compute Engine](https://cloud.google.com/compute/docs/) (GCE)

<!-- Even though https://daringfireball.net/projects/markdown/syntax#block says
8 space, but 6 spaces seem to work better -->
* Create an instance

        gcloud compute instances create dev \
            --zone "us-central1-a" \
            --boot-disk-size 100GB \
            --image container-vm \
            --scopes cloud-platform,storage-rw,bigquery

*  Create an instance from snapshot

I have only done it on console, but this seems unrecommended. Based on
[this page](https://cloud.google.com/compute/docs/instances/creating-and-starting-an-instance),,
Snapshots are more for backup. Use
[Image](https://cloud.google.com/compute/docs/images) instead.

* ssh to an instance, assuming the 

        gcloud compute ssh "dev"

* or ssh to an instance of a specific project in a specific zone

        gcloud compute --project "myproject" ssh --zone "us-central1-a" "dev"

* Copy files between localhost and an instance

        gcloud compute copy-files some_local_file.txt dev:/path/to/target/dir

### [Google Container Engine](https://cloud.google.com/container-engine/docs/)

* Create a container cluster

        # machine of type n1-standard-2 has 2 CPUs & 7.5 GB MEM
        gcloud container clusters create mycluster \
            --num-nodes 3 --machine-type n1-standard-2

  See [here](https://cloud.google.com/compute/docs/machine-types) for all machine types

* List clusters you've created

        gcloud container clusters list

* See the detailed description

        gcloud container clusters describe mycluster

* Passing cluster credentials to kubectl from Kubernetes

        gcloud container clusters get-credentials mycluster

* Delete the cluster with CAUTION

        gcloud container clusters delete mycluster

### [Kubernetes](http://kubernetes.io/v1.1/)

* Create a pod/secret/job/service/replication controller/load balancer

        kubectl create -f config.{yaml, json}

* Check logs of a pod

        # content within $() just extracts the pod name.
        kubectl logs $(kubectl get pods  --output=jsonpath={.items..metadata.name})

* Accessing Kubernetes UI

  Find the server IP, username, password first

      kubectl config view | grep 'server\|password\|username'

  Then go the the server IP address in a browser and follow the
  instruction. More information about UI is available
  [here](https://github.com/kubernetes/kubernetes/blob/v1.0.6/docs/user-guide/ui.md).

## Docker

### Download the tasrcloud image

An image has already been built and named **zyxue/tasrcloud**  on
[Docker Hub](https://hub.docker.com/r/zyxue/tasrcloud/). To download it

    $ docker pull zyxue/tasrcloud:latest


### Launch a container interactively for tasrcloud

    $ docker run --rm -t -i zyxue/tasrcloud /bin/bash

### Launch a container with mounted volume

    $ docker run --rm -t -i -v ${PWD}/refresh-token:/refresh-token zyxue/tasrcloud

BioBloomTools and ABYSS will be available

    root@<container-id>:/# biobloomcategorizer --help

    root@<container-id>:/# abyss-pe --help

### To build the image yourself

    $ git clone git@github.com:bcgsc/tasrcloud.git

    $ cd tasrcloud

    $ docker build <username>/tasrcloud .

If you see a successfully built message, that means the image has been
successfully built. Check with

    $ docker images

For more information about Docker, please try the
[tutorial](https://docs.docker.com/linux/) and read the
[documentation](https://docs.docker.com/).
