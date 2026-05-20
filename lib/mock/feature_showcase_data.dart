// Mock data provider for feature showcase page
class FeatureShowcaseData {
  static const backgroundWatcherData = {
    'newItems': 3,
    'lastScan': '2m ago',
    'status': 'active',
    'icon': '📡',
  };

  static const watcherPipelineData = {
    'newItems': 3,
    'lastScan': '2m ago',
    'status': 'active',
    'stages': ['dedupe', 'identify', 'parse', 'index'],
  };

  static const dedupCompressData = {
    'rawSize': '3 TB',
    'saved': '1.2 TB',
    'ratio': 40,
    'icon': '💾',
    'sections': [
      {
        'label': 'Disk Image',
        'children': [
          {'label': 'Deduplicate'},
          {'label': 'Compress'},
          {
            'label': 'Identify Image Type',
            'children': ['RAW', 'E01', 'VHD/VMDK', 'QCOW2'],
          },
          {'label': 'Parse Image'},
          {
            'label': 'Partition Table',
            'children': ['GPT', 'MBR', 'APFS Container'],
          },
          {
            'label': 'File Systems',
            'children': ['NTFS', 'EXT4', 'APFS', 'FAT32/exFAT'],
          },
          {
            'label': 'Index Entries',
            'children': [
              'Paths',
              'Timestamps',
              'Sizes',
              'Flags',
              'Byte Ranges',
            ],
          },
        ],
      },
    ],
  };

  static const pipelineStages = [
    {'name': 'dedupe', 'status': 'complete', 'icon': '✓'},
    {'name': 'identify', 'status': 'complete', 'icon': '✓'},
    {'name': 'parse', 'status': 'complete', 'icon': '✓'},
    {'name': 'index', 'status': 'complete', 'icon': '✓'},
  ];

  static const microArtifactItems = [
    {'type': 'Event record', 'icon': '📋', 'color': 0xFFE8EDF5},
    {'type': 'Registry value', 'icon': '📝', 'color': 0xFFF0E8F5},
    {'type': 'Extracted string', 'icon': '🔤', 'color': 0xFFE8F5F0},
    {'type': 'PE section', 'icon': '⚙️', 'color': 0xFFFFF5E8},
    {'type': 'Binary signature', 'icon': '📊', 'color': 0xFFF5E8F5},
    {'type': 'Sticky bit', 'icon': '📌', 'color': 0xFFE8F7FF},
    {'type': 'Timestamp', 'icon': '⏰', 'color': 0xFFE8FFF5},
  ];

  static const similaritySearchData = {
    'query': 'config blob',
    'matches': [
      {'case': 'case-42', 'score': 92},
      {'case': 'case-7', 'score': 85},
      {'case': 'case-156', 'score': 78},
      {'case': 'case-3', 'score': 71},
    ],
  };

  static const keywordSearchData = {
    'query': 'persistence',
    'results': [
      'Registry Run key',
      'Scheduled task: updater.exe',
      'Service: suspicioussvc',
    ],
    'highlights': [
      {
        'title': 'Scan Search v2',
        'detail':
            'Upgraded scan-based search fixes race conditions, edge cases, and double counts.',
      },
      {
        'title': 'Query Parser',
        'detail': 'Basic parsing now supports AND, OR, and PHRASE searching.',
      },
      {
        'title': 'Hybrid Search',
        'detail':
            'Full-text search falls back to scan-based search while content indexing completes.',
      },
    ],
    'queries': [
      {
        'keyword': 'persistence AND "updater.exe"',
        'results': [
          'Scheduled task: updater.exe',
          'Registry Run key -> updater.exe',
          'Service launch chain: suspicioussvc -> updater.exe',
        ],
      },
      {
        'keyword': 'beacon OR ransomware',
        'results': [
          'TLS fingerprint: ja3-6f1a',
          'archive_patch_2026.bin',
          'Flow 3190 -> 185.203.118.44:443',
          'triage/ransomware_family_notes.md',
        ],
      },
      {
        'keyword': '"powershell -enc"',
        'results': [
          'Process start: powershell -enc ...',
          'Script block: updater bootstrap',
          'Scheduled task: updater.exe',
        ],
      },
      {
        'keyword': '185.203.118.44 AND beacon',
        'results': [
          'Flow 3190 -> 185.203.118.44:443',
          'pcap/c2_tls_185.203.118.44.json',
          'DNS query: cdn-upd.net',
        ],
      },
      {
        'keyword': '"scheduled task" AND persistence',
        'results': [
          'Scheduled task: updater.exe',
          'Registry Run key',
          'Service: suspicioussvc',
        ],
      },
    ],
  };

  static const similarityIndexData = {
    'queryFile': 'dropper_update_2026.bin',
    'useCase': 'Detecting repackaged malware',
    'methods': [
      {
        'id': 'exact_hash',
        'label': 'Exact file hash match',
        'weight': 100,
        'detail': 'Deterministic full-file equality',
        'color': 0xFFDC2626,
      },
      {
        'id': 'chunk_exact',
        'label': 'Chunk level match',
        'weight': 88,
        'detail': 'Shared fixed-size block signatures',
        'color': 0xFFEA580C,
      },
      {
        'id': 'chunk_partial_simhash',
        'label': 'Partial chunk match via similarity hashing',
        'weight': 72,
        'detail': 'Stable under local edits and padding',
        'color': 0xFFD97706,
      },
      {
        'id': 'topk_full_simhash',
        'label': 'Partial chunk + Top-K full-file simhash',
        'weight': 78,
        'detail': 'Global structure nearest-neighbour ranking',
        'color': 0xFF7C3AED,
      },
      {
        'id': 'vector_match',
        'label': 'Vectorized file embedding match',
        'weight': 69,
        'detail': 'Semantic vector neighborhood overlap',
        'color': 0xFF0EA5E9,
      },
    ],
    'relatedFiles': [
      {
        'file': 'payload_updater_v4.bin',
        'score': 96,
        'matchedBy': ['exact_hash', 'chunk_exact', 'topk_full_simhash'],
        'note': 'Byte-identical core body; renamed wrapper',
        'repackagedLikelihood': 98,
      },
      {
        'file': 'invoice_reader_patch.exe',
        'score': 87,
        'matchedBy': ['chunk_exact', 'chunk_partial_simhash', 'vector_match'],
        'note': 'Shared encrypted loader chunks and API pattern',
        'repackagedLikelihood': 91,
      },
      {
        'file': 'svc_update_signed.dat',
        'score': 81,
        'matchedBy': [
          'chunk_partial_simhash',
          'topk_full_simhash',
          'vector_match',
        ],
        'note': 'Likely repack with altered resource section',
        'repackagedLikelihood': 86,
      },
      {
        'file': 'archive_patch_2026.bin',
        'score': 74,
        'matchedBy': ['topk_full_simhash', 'vector_match'],
        'note': 'Family-level similarity without exact reuse',
        'repackagedLikelihood': 62,
      },
    ],
  };

  static const provenanceGraphData = {
    'nodes': 16,
    'edges': 28,
    'highlight': 'file-123',
    'ingestPath': ['Disk image', 'Partition', 'Indexed file'],
    'indexedFile': 'indexed_file_0142.bin',
    'memoryImage': 'memdump-win11-0410.raw',
    'packetCapture': 'capture-2026-05-10.pcapng',
    'relationChains': [
      {
        'root': 'Executable',
        'steps': [
          {'relation': 'Contains', 'node': 'PE Section'},
          {'relation': 'Similarity', 'node': 'Known Malware String'},
          {'relation': 'Referenced By', 'node': 'Registry Run Key'},
          {'relation': 'Leads To', 'node': 'Process Start Event'},
        ],
      },
      {
        'root': 'Disk image -> partition -> indexed file',
        'steps': [
          {'relation': 'Contains', 'node': '/Users/Public/updater.exe'},
          {'relation': 'Executed As', 'node': 'powershell -enc ...'},
          {'relation': 'Contacts', 'node': '185.203.118.44:443'},
          {'relation': 'Observed In', 'node': 'packet capture flow #2041'},
        ],
      },
      {
        'root': 'Memory Image Artifact',
        'steps': [
          {'relation': 'Backed By', 'node': 'Injected region rwx'},
          {'relation': 'Shares Hash With', 'node': 'Case-7 payload chunk'},
          {'relation': 'Linked To', 'node': 'Scheduled Task updater.exe'},
        ],
      },
      {
        'root': 'Scheduled Task',
        'steps': [
          {'relation': 'Created By', 'node': 'powershell -enc ...'},
          {'relation': 'Executes', 'node': 'dropped_updater.dll'},
          {'relation': 'Triggers', 'node': 'service host spawn event'},
          {'relation': 'Persists Via', 'node': 'Registry Run Key backup'},
        ],
      },
      {
        'root': 'TLS Fingerprint',
        'steps': [
          {'relation': 'Observed In', 'node': 'packet capture flow #3190'},
          {'relation': 'Matches', 'node': 'Case-156 c2 ja3 profile'},
          {'relation': 'Correlates To', 'node': 'DNS query cdn-upd[.]net'},
          {'relation': 'Linked To', 'node': 'mutex beacon global\\svc_upd'},
        ],
      },
    ],
    'boardNodes': [
      'downloaded_file',
      'browser_name',
      'mark_of_the_web',
      'exe',
      'registry_connection',
      'ip_address_trace',
      'memory_image',
      'packet_capture',
    ],
    'clusters': [
      {'id': 'c1', 'label': 'Source'},
      {'id': 'c2', 'label': 'Processing'},
      {'id': 'c3', 'label': 'Artifacts'},
    ],
  };

  static const crossCaseLinksData = {
    'reuseHits': 5,
    'clusters': 2,
    'sharedArtifacts': 9,
    'evidenceTypes': ['Disk image', 'RAM capture', 'Network capture'],
    'cases': [
      {
        'id': 'case-42',
        'matches': 12,
        'files': ['disk.dd', 'memory.raw', 'traffic.pcapng'],
      },
      {
        'id': 'case-7',
        'matches': 8,
        'files': ['corp-laptop.E01', 'ram-win11.raw', 'edge-443.pcap'],
      },
      {
        'id': 'case-156',
        'matches': 5,
        'files': ['server-img.dd', 'volatile.raw', 'dns-hunt.pcapng'],
      },
    ],
    'links': [
      {
        'from': 'case-42/disk.dd',
        'to': 'case-7/corp-laptop.E01',
        'artifact': 'autorun hash',
      },
      {
        'from': 'case-42/memory.raw',
        'to': 'case-156/volatile.raw',
        'artifact': 'mutex beacon',
      },
      {
        'from': 'case-7/edge-443.pcap',
        'to': 'case-156/dns-hunt.pcapng',
        'artifact': 'c2 domain',
      },
      {
        'from': 'case-42/traffic.pcapng',
        'to': 'case-7/edge-443.pcap',
        'artifact': 'ja3 fingerprint',
      },
    ],
  };

  static const exportFormats = [
    {'format': 'JSON', 'icon': '{ }', 'color': 0xFFFFE8CC},
    {'format': 'CSV', 'icon': '⊞', 'color': 0xFFE8F0FF},
    {'format': 'SQLite', 'icon': '🗄️', 'color': 0xFFE8FFE8},
    {'format': 'CASE', 'icon': '📦', 'color': 0xFFFFE8E8},
    {'format': 'YARA', 'icon': '🎯', 'color': 0xFFF0E8FF},
  ];

  static const feedbackLoopData = {
    'pending': 8,
    'verified': 12,
    'rejected': 2,
    'successRate': 86,
  };

  static const liveTriageData = {
    'agentInstalled': false,
    'ramSnapshot': 'on_demand',
    'lastCollection': '5h ago',
    'status': 'ready',
  };
}
