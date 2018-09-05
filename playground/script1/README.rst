Building Your First Network
===========================

.. note:: These instructions have been verified to work against the
          latest stable Docker images and the pre-compiled
          setup utilities within the supplied tar file. If you run
          these commands with images or tools from the current master
          branch, it is possible that you will see configuration and panic
          errors.

The build your first network (BYFN) scenario provisions a sample Hyperledger
Fabric network consisting of two organizations, each maintaining two peer
nodes, and a "solo" ordering service.

Install prerequisites
---------------------

Before we begin, if you haven't already done so, you may wish to check that
you have all the :doc:`prereqs` installed on the platform(s)
on which you'll be developing blockchain applications and/or operating
Hyperledger Fabric.

You will also need to :doc:`install`. You will notice
that there are a number of samples included in the ``fabric-samples``
repository. We will be using the ``first-network`` sample. Let's open that
sub-directory now.

.. code:: bash

  cd fabric-samples/first-network

.. note:: The supplied commands in this documentation
          **MUST** be run from your ``first-network`` sub-directory
          of the ``fabric-samples`` repository clone.  If you elect to run the
          commands from a different location, the various provided scripts
          will be unable to find the binaries.

Want to run it now?
-------------------

We provide a fully annotated script - ``byfn.sh`` - that leverages these Docker
images to quickly bootstrap a Hyperledger Fabric network comprised of 4 peers
representing two different organizations, and an orderer node. It will also
launch a container to run a scripted execution that will join peers to a
channel, deploy and instantiate chaincode and drive execution of transactions
against the deployed chaincode.

Here's the help text for the ``byfn.sh`` script:

.. code:: bash

  Usage:
    byfn.sh <mode> [-c <channel name>] [-t <timeout>] [-d <delay>] [-f <docker-compose-file>] [-s <dbtype>] [-l <language>] [-i <imagetag>] [-v]
      <mode> - one of 'up', 'down', 'restart', 'generate' or 'upgrade'
        - 'up' - bring up the network with docker-compose up
        - 'down' - clear the network with docker-compose down
        - 'restart' - restart the network
        - 'generate' - generate required certificates and genesis block
        - 'upgrade'  - upgrade the network from v1.0.x to v1.1
      -c <channel name> - channel name to use (defaults to "mychannel")
      -t <timeout> - CLI timeout duration in seconds (defaults to 10)
      -d <delay> - delay duration in seconds (defaults to 3)
      -f <docker-compose-file> - specify which docker-compose file use (defaults to docker-compose-cli.yaml)
      -s <dbtype> - the database backend to use: goleveldb (default) or couchdb
      -l <language> - the chaincode language: golang (default) or node
      -i <imagetag> - the tag to be used to launch the network (defaults to "latest")
      -v - verbose mode
    byfn.sh -h (print this message)

  Typically, one would first generate the required certificates and
  genesis block, then bring up the network. e.g.:

	  byfn.sh generate -c mychannel
	  byfn.sh up -c mychannel -s couchdb
          byfn.sh up -c mychannel -s couchdb -i 1.1.0-alpha
	  byfn.sh up -l node
	  byfn.sh down -c mychannel
          byfn.sh upgrade -c mychannel

  Taking all defaults:
	  byfn.sh generate
	  byfn.sh up
	  byfn.sh down

If you choose not to supply a channel name, then the
script will use a default name of ``mychannel``.  The CLI timeout parameter
(specified with the -t flag) is an optional value; if you choose not to set
it, then the CLI will give up on query requests made after the default
setting of 10 seconds.

Generate Network Artifacts
^^^^^^^^^^^^^^^^^^^^^^^^^^

Ready to give it a go? Okay then! Execute the following command:

.. code:: bash

  ./byfn.sh generate

You will see a brief description as to what will occur, along with a yes/no command line
prompt. Respond with a ``y`` or hit the return key to execute the described action.

.. code:: bash

  Generating certs and genesis block for with channel 'mychannel' and CLI timeout of '10'
  Continue? [Y/n] y
  proceeding ...
  /Users/xxx/dev/fabric-samples/bin/cryptogen

  ##########################################################
  ##### Generate certificates using cryptogen tool #########
  ##########################################################
  org1.example.com
  2017-06-12 21:01:37.334 EDT [bccsp] GetDefault -> WARN 001 Before using BCCSP, please call InitFactories(). Falling back to bootBCCSP.
  ...

  /Users/xxx/dev/fabric-samples/bin/configtxgen
  ##########################################################
  #########  Generating Orderer Genesis block ##############
  ##########################################################
  2017-06-12 21:01:37.558 EDT [common/configtx/tool] main -> INFO 001 Loading configuration
  2017-06-12 21:01:37.562 EDT [msp] getMspConfig -> INFO 002 intermediate certs folder not found at [/Users/xxx/dev/byfn/crypto-config/ordererOrganizations/example.com/msp/intermediatecerts]. Skipping.: [stat /Users/xxx/dev/byfn/crypto-config/ordererOrganizations/example.com/msp/intermediatecerts: no such file or directory]
  ...
  2017-06-12 21:01:37.588 EDT [common/configtx/tool] doOutputBlock -> INFO 00b Generating genesis block
  2017-06-12 21:01:37.590 EDT [common/configtx/tool] doOutputBlock -> INFO 00c Writing genesis block

  #################################################################
  ### Generating channel configuration transaction 'channel.tx' ###
  #################################################################
  2017-06-12 21:01:37.634 EDT [common/configtx/tool] main -> INFO 001 Loading configuration
  2017-06-12 21:01:37.644 EDT [common/configtx/tool] doOutputChannelCreateTx -> INFO 002 Generating new channel configtx
  2017-06-12 21:01:37.645 EDT [common/configtx/tool] doOutputChannelCreateTx -> INFO 003 Writing new channel tx

  #################################################################
  #######    Generating anchor peer update for Org1MSP   ##########
  #################################################################
  2017-06-12 21:01:37.674 EDT [common/configtx/tool] main -> INFO 001 Loading configuration
  2017-06-12 21:01:37.678 EDT [common/configtx/tool] doOutputAnchorPeersUpdate -> INFO 002 Generating anchor peer update
  2017-06-12 21:01:37.679 EDT [common/configtx/tool] doOutputAnchorPeersUpdate -> INFO 003 Writing anchor peer update

  #################################################################
  #######    Generating anchor peer update for Org2MSP   ##########
  #################################################################
  2017-06-12 21:01:37.700 EDT [common/configtx/tool] main -> INFO 001 Loading configuration
  2017-06-12 21:01:37.704 EDT [common/configtx/tool] doOutputAnchorPeersUpdate -> INFO 002 Generating anchor peer update
  2017-06-12 21:01:37.704 EDT [common/configtx/tool] doOutputAnchorPeersUpdate -> INFO 003 Writing anchor peer update

This first step generates all of the certificates and keys for our various
network entities, the ``genesis block`` used to bootstrap the ordering service,
and a collection of configuration transactions required to configure a
:ref:`Channel`.

Bring Up the Network
^^^^^^^^^^^^^^^^^^^^

Next, you can bring the network up with one of the following commands:

.. code:: bash

  ./byfn.sh up

The above command will compile Golang chaincode images and spin up the corresponding
containers.  Go is the default chaincode language, however there is also support
for `Node.js <https://fabric-shim.github.io/>`__ chaincode.  If you'd like to run through this tutorial with node
chaincode, pass the following command instead:

.. code:: bash

  # we use the -l flag to specify the chaincode language
  # forgoing the -l flag will default to Golang

  ./byfn.sh up -l node

.. note:: View the `Hyperledger Fabric Shim <https://fabric-shim.github.io/ChaincodeStub.html>`__
          documentation for more info on the node.js chaincode shim APIs.

Once again, you will be prompted as to whether you wish to continue or abort.
Respond with a ``y`` or hit the return key:

.. code:: bash

  Starting with channel 'mychannel' and CLI timeout of '10'
  Continue? [Y/n]
  proceeding ...
  Creating network "net_byfn" with the default driver
  Creating peer0.org1.example.com
  Creating peer1.org1.example.com
  Creating peer0.org2.example.com
  Creating orderer.example.com
  Creating peer1.org2.example.com
  Creating cli


   ____    _____      _      ____    _____
  / ___|  |_   _|    / \    |  _ \  |_   _|
  \___ \    | |     / _ \   | |_) |   | |
   ___) |   | |    / ___ \  |  _ <    | |
  |____/    |_|   /_/   \_\ |_| \_\   |_|

  Channel name : mychannel
  Creating channel...

The logs will continue from there. This will launch all of the containers, and
then drive a complete end-to-end application scenario. Upon successful
completion, it should report the following in your terminal window:

.. code:: bash

    Query Result: 90
    2017-05-16 17:08:15.158 UTC [main] main -> INFO 008 Exiting.....
    ===================== Query successful on peer1.org2 on channel 'mychannel' =====================

    ===================== All GOOD, BYFN execution completed =====================


     _____   _   _   ____
    | ____| | \ | | |  _ \
    |  _|   |  \| | | | | |
    | |___  | |\  | | |_| |
    |_____| |_| \_| |____/

You can scroll through these logs to see the various transactions. If you don't
get this result, then jump down to the :ref:`Troubleshoot` section and let's see
whether we can help you discover what went wrong.

Bring Down the Network
^^^^^^^^^^^^^^^^^^^^^^

Finally, let's bring it all down so we can explore the network setup one step
at a time. The following will kill your containers, remove the crypto material
and four artifacts, and delete the chaincode images from your Docker Registry:

.. code:: bash

  ./byfn.sh down

Once again, you will be prompted to continue, respond with a ``y`` or hit the return key:

.. code:: bash

  Stopping with channel 'mychannel' and CLI timeout of '10'
  Continue? [Y/n] y
  proceeding ...
  WARNING: The CHANNEL_NAME variable is not set. Defaulting to a blank string.
  WARNING: The TIMEOUT variable is not set. Defaulting to a blank string.
  Removing network net_byfn
  468aaa6201ed
  ...
  Untagged: dev-peer1.org2.example.com-mycc-1.0:latest
  Deleted: sha256:ed3230614e64e1c83e510c0c282e982d2b06d148b1c498bbdcc429e2b2531e91
  ...

If you'd like to learn more about the underlying tooling and bootstrap mechanics,
continue reading.  In these next sections we'll walk through the various steps
and requirements to build a fully-functional Hyperledger Fabric network.

.. note:: The manual steps outlined below assume that the ``CORE_LOGGING_LEVEL`` in
          the ``cli`` container is set to ``DEBUG``. You can set this by modifying
          the ``docker-compose-cli.yaml`` file in the ``first-network`` directory.
          e.g.

          .. code::

            cli:
              container_name: cli
              image: hyperledger/fabric-tools:$IMAGE_TAG
              tty: true
              stdin_open: true
              environment:
                - GOPATH=/opt/gopath
                - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
                - CORE_LOGGING_LEVEL=DEBUG
                #- CORE_LOGGING_LEVEL=INFO

Crypto Generator
