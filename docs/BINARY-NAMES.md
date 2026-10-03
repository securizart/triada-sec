# Binary names (package name != executable)

Some Debian/Kali packages install an executable whose name differs from the
package name. The Phase 4 installer and any verification check must test
`command -v <binary>`, NOT the package name, for these.

| Package          | Binary(ies)                     | Notes                          |
|------------------|---------------------------------|--------------------------------|
| testssl.sh       | testssl                         | drops the `.sh`                |
| maskprocessor    | mp64, mp32                      | use mp64 on arm64              |
| statsprocessor   | sp64, sp32                      | use sp64 on arm64              |
| hcxkeys          | wlangenpmk, wlangenpmkocl       | `ocl` = OpenCL/GPU variant     |
| afl++            | afl-fuzz, afl-cc (+afl-gcc...)        | package `afl++`, bins `afl-*`   |
| spike            | generic_send_tcp, generic_listen_tcp | no `spike` binary               |
| sipvicious       | svmap, svwar, svcrack, svreport, svcrash | all `sv*`                   |

<!-- keep this table updated as new renamed-binary packages are added -->
