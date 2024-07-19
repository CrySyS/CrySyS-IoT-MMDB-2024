# CrySyS IoT Malware Metadata DataBase 2024

The rapid development of the Internet-of-Things (IoT) has led to many innovative applications, but at the same time, it made
IoT devices a common target for malicious actors. In particular, diverse malware families for IoT devices have appeared in
the recent past. Our project aims at contributing to the research fields of IoT malware detection and classification by creating
publicly available IoT malware metadata databases. We created these databases by cleaning five malware sample datasets,
made available by Yokohama National University (YNU), and extracting valuable metadata from the samples and their VirusTotal
analysis reports. Our databases contain metadata for 55,497 samples compiled for the ARM architecture and 46,134 samples
compiled for the MIPS architecture that are verified malware based on their VirusTotal reports.

More specifically, our databases contain metadata of a carefully selected subset of the samples in [five previously published IoT malware datasets](https://sec.ynu.codes/iot/available_datasets#1). These datasets (denoted by A, B, C, D-1, and D-2) were constructed by researchers of the Yokohama National University (YNU) by capturing potentially malicious files with two IoT honeypots [1,2]. We cleaned these datasets by filtering out samples that cannot be considered malware with high enough confidence, and collected useful metadata of the remaining, likely-to-be malware samples. Part of the metadata were extracted from the samples themselves, while some other metadata were extracted from their VirusTotal (VT) reports. We publish here the collected metadata in the form of graph-based databases, using Neo4j. This allows users to execute various queries on and to select various subsets of the original IoT malware samples based on their metadata. The graph-based nature of the databases also allows users to execute similarity searches on the samples. The samples themselves are not part of our published databases; they can be retrieved, if needed, from the original, publicly available datasets or from VirusTotal based on their SHA256 hash values (which we do store among the metadata).

## Description of the databases

The databases contain metadata for 55,497 ELF binaries compiled for the ARM platform and 46,134 ELF binaries compiled for the MIPS platform. The following table shows how many samples were compiled for 32-bit or 64-bit architectures, based on the information in their headers. All samples are executable files.

|        | ARM    | MIPS   |
| ------ | ------ | ------ |
| 32-bit | 55,481 | 46,114 |
| 64-bit | 16     | 20     |

Regarding the linking of ARM and MIPS samples, the following table shows how many samples are linked statically, dynamically, or unknown.

|                    | ARM    | MIPS   |
| ------------------ | ------ | ------ |
| statically linked  | 49,755 | 45,822 |
| dynamically linked | 5,523  | 225    |
| unknown            | 219    | 87     |

The majority of the samples covered by our databases are from a few bytes to around 400KB in size. Regarding ARM samples, 127 samples are larger than 400 KiB, with the largest file being 8.86 MB. Among the MIPS samples, 225 are larger than 400 KiB, with the largest file size being 9.79 MB.

Based on our entropy analysis of the binaries, we found that the majority of samples are either native executables or packed. However, there are a few samples with a high entropy value, indicating the presence of encrypted files as well.

## Content of this repository

```
.
|-- README.md
|-- docker-compose.yml
|-- dockerfile
`-- dumps
    |-- arm
    |   `-- neo4j_5.18.1_maintaned.dump
    `-- mips
        `-- neo4j_5.18.1_maintaned.dump
```

`docker-compose.yml`: Configuration file for setting up and managing the Docker container(s) for Neo4j.

`dockerfile`: Instructions to build the Docker image for Neo4j.

`dumps directory`: Contains Neo4j data dumps for different CPU architectures.
- `arm/neo4j_5.18.1_maintaned.dump`: Dump of metadata for ARM samples.
- `mips/neo4j_5.18.1_maintaned.dump`: Dump of metadata for ARM samples.


## How to get the metadata of the malware samples and the binaries themselves?

To access the databases, issue the following command:
`docker compose up --build -d`

The databases are available at the following addresses:
- ARM: `http://localhost:7474`
- MIPS: `http://localhost:7475`

The APIs is available at the following addresses:
- ARM: `neo4j://localhost:7687`
- MIPS: `neo4j://localhost:7688`

The username and the password are: `neo4j/iotmalware` (these parameters can be modified in the `dockerfile`).

It is important to note that container access primarily supports retrieving metadata and does not involve manipulating database content. The data is compiled into the containers, and once the containers are deleted, all modifications are lost.

If persistence is required, it is possible to mount volumes into the containers and store the database files in them (see the commented lines in the `docker-compose.yml` file). In this case however, the dumps must be loaded into the database again using the following command:

```bash
docker exec <container_name> neo4j-admin database load --from-path=/var/lib/neo4j/import --overwrite-destination=true --verbose neo4j
```

The alternative approach is to use dump files, which require the installation of a Neo4j database with a version number equal to or greater than the version number specified in the dump file name. To do this, copy the required dump file to the import folder of Neo4j and issue the following command:

```bash
neo4j-admin database load --from-path=/var/lib/neo4j/import --overwrite-destination=true --verbose neo4j
```

If required, raw binaries can be obtained from the [original datasets](https://sec.ynu.codes/iot/available_datasets#1) using their SHA256 hash value, or samples can be similarly downloaded from VirusTotal.

## Acknowledgement

The research presented in this paper was supported by the European Union project RRF-2.3.1-21-2022-00004 within the framework of the Artificial Intelligence National Laboratory and by the European Union’s Horizon Europe Research and Innovation Program through the [DOSS Project](https://dossproject.eu/) (Grant Number 101120270). The presented work also builds on results of the [SETIT Project](https://www.crysys.hu/research/setit/) (2018-1.2.1-NKP-2018-00004), which was implemented with the support provided from the [National Research, Development and Innovation Fund of Hungary](https://mi.nemzetilabor.hu/), financed under the 2018-1.2.1-NKP funding scheme. The authors are also thankful to [VirusTotal](https://www.virustotal.com/) for the academic license provided for research purposes.

## References

[1] Yin Minn Pa Pa, Suzuki Shogo, Katsunari Yoshioka, Tsutomu Matsumoto, Takahiro Kasama, Christian Rossow "IoTPOT: A Novel Honeypot for Revealing Current IoT Threats," Journal of Information Processing, Vol.57, No. 4, 2016.

[2] Yin Minn Pa Pa, Shogo Suzuki, Katsunari Yoshioka, and Tsutomu Matsumoto, Takahiro Kasama, Christian Rossow, "IoTPOT: Analysing the Rise of IoT Compromises," 9th USENIX Workshop on Offensive Technologies (USENIX WOOT 2015), 2015.
