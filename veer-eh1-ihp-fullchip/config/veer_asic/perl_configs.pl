#  NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE NOTE
#  This is an automatically generated file by  on Sun Sep 20 04:36:54 ADT 2026
# 
#  cmd:    veer -target=default_pd -ahb_lite -set=dccm_enable=0 -set=iccm_enable=0 -set=icache_enable=0 -unset=assert_on 
# 
# To use this in a perf script, use 'require $RV_ROOT/configs/config.pl'
# Reference the hash via $config{name}..


%config = (
            'core' => {
                        'lsu_num_nbload' => '8',
                        'dec_instbuf_depth' => '4',
                        'dma_buf_depth' => '4',
                        'lsu_stbuf_depth' => '8',
                        'lsu_num_nbload_width' => '3'
                      },
            'physical' => '1',
            'btb' => {
                       'btb_index3_hi' => 9,
                       'btb_index2_lo' => 6,
                       'btb_index1_lo' => '4',
                       'btb_addr_lo' => '4',
                       'btb_btag_size' => 9,
                       'btb_size' => 32,
                       'btb_btag_fold' => 1,
                       'btb_index2_hi' => 7,
                       'btb_array_depth' => 4,
                       'btb_addr_hi' => 5,
                       'btb_index3_lo' => 8,
                       'btb_index1_hi' => 5
                     },
            'xlen' => 32,
            'csr' => {
                       'micect' => {
                                     'exists' => 'true',
                                     'number' => '0x7f0',
                                     'mask' => '0xffffffff',
                                     'reset' => '0x0'
                                   },
                       'dicad0' => {
                                     'number' => '0x7c9',
                                     'mask' => '0xffffffff',
                                     'reset' => '0x0',
                                     'exists' => 'true',
                                     'comment' => 'Cache diagnostics.',
                                     'debug' => 'true'
                                   },
                       'mhpmevent5' => {
                                         'exists' => 'true',
                                         'mask' => '0xffffffff',
                                         'reset' => '0x0'
                                       },
                       'mhpmevent4' => {
                                         'exists' => 'true',
                                         'mask' => '0xffffffff',
                                         'reset' => '0x0'
                                       },
                       'pmpaddr0' => {
                                       'exists' => 'false'
                                     },
                       'mimpid' => {
                                     'exists' => 'true',
                                     'mask' => '0x0',
                                     'reset' => '0x6'
                                   },
                       'meicpct' => {
                                      'exists' => 'true',
                                      'comment' => 'External claim id/priority capture.',
                                      'reset' => '0x0',
                                      'mask' => '0x0',
                                      'number' => '0xbca'
                                    },
                       'dmst' => {
                                   'reset' => '0x0',
                                   'mask' => '0x0',
                                   'number' => '0x7c4',
                                   'exists' => 'true',
                                   'debug' => 'true',
                                   'comment' => 'Memory synch trigger: Flush caches in debug mode.'
                                 },
                       'mstatus' => {
                                      'exists' => 'true',
                                      'reset' => '0x1800',
                                      'mask' => '0x88'
                                    },
                       'mhpmcounter5' => {
                                           'exists' => 'true',
                                           'reset' => '0x0',
                                           'mask' => '0xffffffff'
                                         },
                       'pmpaddr6' => {
                                       'exists' => 'false'
                                     },
                       'pmpaddr13' => {
                                        'exists' => 'false'
                                      },
                       'mitbnd0' => {
                                      'exists' => 'true',
                                      'number' => '0x7d3',
                                      'mask' => '0xffffffff',
                                      'reset' => '0xffffffff'
                                    },
                       'mitcnt1' => {
                                      'exists' => 'true',
                                      'number' => '0x7d5',
                                      'reset' => '0x0',
                                      'mask' => '0xffffffff'
                                    },
                       'marchid' => {
                                      'mask' => '0x0',
                                      'reset' => '0x0000000b',
                                      'exists' => 'true'
                                    },
                       'dicago' => {
                                     'mask' => '0x0',
                                     'reset' => '0x0',
                                     'number' => '0x7cb',
                                     'debug' => 'true',
                                     'comment' => 'Cache diagnostics.',
                                     'exists' => 'true'
                                   },
                       'pmpaddr11' => {
                                        'exists' => 'false'
                                      },
                       'pmpaddr5' => {
                                       'exists' => 'false'
                                     },
                       'pmpcfg1' => {
                                      'exists' => 'false'
                                    },
                       'mie' => {
                                  'mask' => '0x70000888',
                                  'reset' => '0x0',
                                  'exists' => 'true'
                                },
                       'mitctl1' => {
                                      'exists' => 'true',
                                      'number' => '0x7d7',
                                      'reset' => '0x1',
                                      'mask' => '0x00000007'
                                    },
                       'meipt' => {
                                    'exists' => 'true',
                                    'comment' => 'External interrupt priority threshold.',
                                    'reset' => '0x0',
                                    'mask' => '0xf',
                                    'number' => '0xbc9'
                                  },
                       'pmpaddr8' => {
                                       'exists' => 'false'
                                     },
                       'pmpaddr4' => {
                                       'exists' => 'false'
                                     },
                       'pmpaddr15' => {
                                        'exists' => 'false'
                                      },
                       'mhpmcounter6' => {
                                           'reset' => '0x0',
                                           'mask' => '0xffffffff',
                                           'exists' => 'true'
                                         },
                       'pmpaddr10' => {
                                        'exists' => 'false'
                                      },
                       'mhpmcounter3h' => {
                                            'mask' => '0xffffffff',
                                            'reset' => '0x0',
                                            'exists' => 'true'
                                          },
                       'dicawics' => {
                                       'exists' => 'true',
                                       'debug' => 'true',
                                       'comment' => 'Cache diagnostics.',
                                       'reset' => '0x0',
                                       'mask' => '0x0130fffc',
                                       'number' => '0x7c8'
                                     },
                       'misa' => {
                                   'exists' => 'true',
                                   'reset' => '0x40001104',
                                   'mask' => '0x0'
                                 },
                       'mcountinhibit' => {
                                            'exists' => 'false'
                                          },
                       'mip' => {
                                  'poke_mask' => '0x70000888',
                                  'reset' => '0x0',
                                  'mask' => '0x0',
                                  'exists' => 'true'
                                },
                       'meicurpl' => {
                                       'comment' => 'External interrupt current priority level.',
                                       'exists' => 'true',
                                       'number' => '0xbcc',
                                       'mask' => '0xf',
                                       'reset' => '0x0'
                                     },
                       'instret' => {
                                      'exists' => 'false'
                                    },
                       'mhpmcounter4' => {
                                           'mask' => '0xffffffff',
                                           'reset' => '0x0',
                                           'exists' => 'true'
                                         },
                       'mcpc' => {
                                   'exists' => 'true',
                                   'mask' => '0x0',
                                   'reset' => '0x0',
                                   'number' => '0x7c2'
                                 },
                       'mfdc' => {
                                   'number' => '0x7f9',
                                   'mask' => '0x000727ff',
                                   'reset' => '0x00070000',
                                   'exists' => 'true'
                                 },
                       'pmpaddr9' => {
                                       'exists' => 'false'
                                     },
                       'mgpmc' => {
                                    'reset' => '0x1',
                                    'mask' => '0x1',
                                    'number' => '0x7d0',
                                    'exists' => 'true'
                                  },
                       'mitctl0' => {
                                      'number' => '0x7d4',
                                      'reset' => '0x1',
                                      'mask' => '0x00000007',
                                      'exists' => 'true'
                                    },
                       'mhpmcounter3' => {
                                           'exists' => 'true',
                                           'reset' => '0x0',
                                           'mask' => '0xffffffff'
                                         },
                       'pmpcfg0' => {
                                      'exists' => 'false'
                                    },
                       'mhpmcounter6h' => {
                                            'reset' => '0x0',
                                            'mask' => '0xffffffff',
                                            'exists' => 'true'
                                          },
                       'mhpmcounter4h' => {
                                            'reset' => '0x0',
                                            'mask' => '0xffffffff',
                                            'exists' => 'true'
                                          },
                       'mhpmevent6' => {
                                         'exists' => 'true',
                                         'reset' => '0x0',
                                         'mask' => '0xffffffff'
                                       },
                       'mcgc' => {
                                   'poke_mask' => '0x000001ff',
                                   'number' => '0x7f8',
                                   'mask' => '0x000001ff',
                                   'reset' => '0x0',
                                   'exists' => 'true'
                                 },
                       'mpmc' => {
                                   'exists' => 'true',
                                   'comment' => 'FWHALT',
                                   'mask' => '0x2',
                                   'reset' => '0x2',
                                   'number' => '0x7c6',
                                   'poke_mask' => '0x2'
                                 },
                       'pmpaddr12' => {
                                        'exists' => 'false'
                                      },
                       'mdccmect' => {
                                       'number' => '0x7f2',
                                       'mask' => '0xffffffff',
                                       'reset' => '0x0',
                                       'exists' => 'true'
                                     },
                       'mhpmevent3' => {
                                         'mask' => '0xffffffff',
                                         'reset' => '0x0',
                                         'exists' => 'true'
                                       },
                       'mcounteren' => {
                                         'exists' => 'false'
                                       },
                       'pmpaddr3' => {
                                       'exists' => 'false'
                                     },
                       'dicad1' => {
                                     'exists' => 'true',
                                     'debug' => 'true',
                                     'comment' => 'Cache diagnostics.',
                                     'mask' => '0x3',
                                     'reset' => '0x0',
                                     'number' => '0x7ca'
                                   },
                       'pmpaddr7' => {
                                       'exists' => 'false'
                                     },
                       'pmpcfg3' => {
                                      'exists' => 'false'
                                    },
                       'tselect' => {
                                      'exists' => 'true',
                                      'reset' => '0x0',
                                      'mask' => '0x3'
                                    },
                       'mvendorid' => {
                                        'exists' => 'true',
                                        'mask' => '0x0',
                                        'reset' => '0x45'
                                      },
                       'time' => {
                                   'exists' => 'false'
                                 },
                       'pmpaddr14' => {
                                        'exists' => 'false'
                                      },
                       'pmpaddr2' => {
                                       'exists' => 'false'
                                     },
                       'mitbnd1' => {
                                      'exists' => 'true',
                                      'reset' => '0xffffffff',
                                      'mask' => '0xffffffff',
                                      'number' => '0x7d6'
                                    },
                       'dcsr' => {
                                   'exists' => 'true',
                                   'reset' => '0x40000003',
                                   'mask' => '0x00008c04',
                                   'poke_mask' => '0x00008dcc'
                                 },
                       'miccmect' => {
                                       'number' => '0x7f1',
                                       'mask' => '0xffffffff',
                                       'reset' => '0x0',
                                       'exists' => 'true'
                                     },
                       'cycle' => {
                                    'exists' => 'false'
                                  },
                       'pmpcfg2' => {
                                      'exists' => 'false'
                                    },
                       'mhpmcounter5h' => {
                                            'mask' => '0xffffffff',
                                            'reset' => '0x0',
                                            'exists' => 'true'
                                          },
                       'pmpaddr1' => {
                                       'exists' => 'false'
                                     },
                       'meicidpl' => {
                                       'comment' => 'External interrupt claim id priority level.',
                                       'exists' => 'true',
                                       'mask' => '0xf',
                                       'reset' => '0x0',
                                       'number' => '0xbcb'
                                     },
                       'mitcnt0' => {
                                      'mask' => '0xffffffff',
                                      'reset' => '0x0',
                                      'number' => '0x7d2',
                                      'exists' => 'true'
                                    }
                     },
            'numiregs' => '32',
            'icache' => {
                          'icache_enable' => '0',
                          'icache_ic_depth' => 8,
                          'icache_size' => 16,
                          'icache_taddr_high' => 5,
                          'icache_ic_rows' => '256',
                          'icache_tag_low' => '6',
                          'icache_tag_high' => 12,
                          'icache_data_cell' => 'ram_256x34',
                          'icache_tag_depth' => 64,
                          'icache_tag_cell' => 'ram_64x21',
                          'icache_ic_index' => 8
                        },
            'bht' => {
                       'bht_ghr_pad2' => 'fghr[4:3],2\'b0',
                       'bht_ghr_pad' => 'fghr[4],3\'b0',
                       'bht_array_depth' => 16,
                       'bht_addr_hi' => 7,
                       'bht_ghr_size' => 5,
                       'bht_hash_string' => '{ghr[3:2] ^ {ghr[3+1], {4-1-2{1\'b0} } },hashin[5:4]^ghr[2-1:0]}',
                       'bht_size' => 128,
                       'bht_ghr_range' => '4:0',
                       'bht_addr_lo' => '4'
                     },
            'retstack' => {
                            'ret_stack_size' => '4'
                          },
            'max_mmode_perf_event' => '50',
            'memmap' => {
                          'unused_region0' => '0x00000000',
                          'external_data_1' => '0x00000000',
                          'unused_region2' => '0x20000000',
                          'unused_region6' => '0x60000000',
                          'external_data' => '0xc0580000',
                          'consoleio' => '0xd0580000',
                          'unused_region3' => '0x30000000',
                          'serialio' => '0xd0580000',
                          'unused_region5' => '0x50000000',
                          'debug_sb_mem' => '0xb0580000',
                          'unused_region9' => '0x90000000',
                          'unused_region1' => '0x10000000',
                          'external_prog' => '0xb0000000',
                          'unused_region7' => '0x70000000',
                          'unused_region4' => '0x40000000'
                        },
            'tec_rv_icg' => 'clockhdr',
            'protection' => {
                              'data_access_addr4' => '0x00000000',
                              'data_access_mask7' => '0xffffffff',
                              'inst_access_addr6' => '0x00000000',
                              'data_access_mask0' => '0xffffffff',
                              'data_access_mask5' => '0xffffffff',
                              'data_access_enable1' => '0x0',
                              'data_access_addr0' => '0x00000000',
                              'data_access_addr5' => '0x00000000',
                              'data_access_mask4' => '0xffffffff',
                              'data_access_enable3' => '0x0',
                              'data_access_addr7' => '0x00000000',
                              'inst_access_mask6' => '0xffffffff',
                              'inst_access_enable2' => '0x0',
                              'data_access_addr1' => '0x00000000',
                              'data_access_enable7' => '0x0',
                              'data_access_enable5' => '0x0',
                              'inst_access_mask3' => '0xffffffff',
                              'inst_access_addr2' => '0x00000000',
                              'inst_access_enable0' => '0x0',
                              'inst_access_addr3' => '0x00000000',
                              'inst_access_enable6' => '0x0',
                              'inst_access_mask2' => '0xffffffff',
                              'inst_access_enable4' => '0x0',
                              'data_access_mask1' => '0xffffffff',
                              'data_access_enable0' => '0x0',
                              'data_access_addr3' => '0x00000000',
                              'data_access_enable6' => '0x0',
                              'data_access_mask2' => '0xffffffff',
                              'data_access_enable4' => '0x0',
                              'inst_access_mask1' => '0xffffffff',
                              'data_access_enable2' => '0x0',
                              'inst_access_addr1' => '0x00000000',
                              'inst_access_enable7' => '0x0',
                              'inst_access_enable5' => '0x0',
                              'data_access_mask3' => '0xffffffff',
                              'data_access_addr2' => '0x00000000',
                              'inst_access_enable1' => '0x0',
                              'inst_access_addr0' => '0x00000000',
                              'inst_access_addr5' => '0x00000000',
                              'inst_access_mask4' => '0xffffffff',
                              'inst_access_addr7' => '0x00000000',
                              'data_access_mask6' => '0xffffffff',
                              'inst_access_enable3' => '0x0',
                              'inst_access_addr4' => '0x00000000',
                              'inst_access_mask7' => '0xffffffff',
                              'data_access_addr6' => '0x00000000',
                              'inst_access_mask0' => '0xffffffff',
                              'inst_access_mask5' => '0xffffffff'
                            },
            'num_mmode_perf_regs' => '4',
            'even_odd_trigger_chains' => 'true',
            'triggers' => [
                            {
                              'poke_mask' => [
                                               '0x081818c7',
                                               '0xffffffff',
                                               '0x00000000'
                                             ],
                              'reset' => [
                                           '0x23e00000',
                                           '0x00000000',
                                           '0x00000000'
                                         ],
                              'mask' => [
                                          '0x081818c7',
                                          '0xffffffff',
                                          '0x00000000'
                                        ]
                            },
                            {
                              'poke_mask' => [
                                               '0x081810c7',
                                               '0xffffffff',
                                               '0x00000000'
                                             ],
                              'reset' => [
                                           '0x23e00000',
                                           '0x00000000',
                                           '0x00000000'
                                         ],
                              'mask' => [
                                          '0x081810c7',
                                          '0xffffffff',
                                          '0x00000000'
                                        ]
                            },
                            {
                              'poke_mask' => [
                                               '0x081818c7',
                                               '0xffffffff',
                                               '0x00000000'
                                             ],
                              'mask' => [
                                          '0x081818c7',
                                          '0xffffffff',
                                          '0x00000000'
                                        ],
                              'reset' => [
                                           '0x23e00000',
                                           '0x00000000',
                                           '0x00000000'
                                         ]
                            },
                            {
                              'poke_mask' => [
                                               '0x081810c7',
                                               '0xffffffff',
                                               '0x00000000'
                                             ],
                              'mask' => [
                                          '0x081810c7',
                                          '0xffffffff',
                                          '0x00000000'
                                        ],
                              'reset' => [
                                           '0x23e00000',
                                           '0x00000000',
                                           '0x00000000'
                                         ]
                            }
                          ],
            'harts' => 1,
            'bus' => {
                       'dma_bus_tag' => '1',
                       'lsu_bus_tag' => 4,
                       'ifu_bus_tag' => '3',
                       'sb_bus_tag' => '1'
                     },
            'testbench' => {
                             'CPU_TOP' => '`RV_TOP.veer',
                             'SDVT_AHB' => '1',
                             'build_ahb_lite' => '1',
                             'sterr_rollback' => '0',
                             'lderr_rollback' => '1',
                             'RV_TOP' => '`TOP.rvtop',
                             'clock_period' => '100',
                             'datawidth' => '64',
                             'assert_on' => '',
                             'TOP' => 'tb_top',
                             'ext_addrwidth' => '32',
                             'ext_datawidth' => '64'
                           },
            'nmi_vec' => '0x11110000',
            'dccm' => {
                        'dccm_rows' => '1024',
                        'dccm_byte_width' => '4',
                        'dccm_enable' => '0',
                        'dccm_data_cell' => 'ram_1024x39',
                        'dccm_width_bits' => 2,
                        'dccm_size_32' => '',
                        'dccm_region' => '0xf',
                        'dccm_data_width' => 32,
                        'dccm_bank_bits' => 3,
                        'dccm_eadr' => '0xf0047fff',
                        'dccm_ecc_width' => 7,
                        'dccm_offset' => '0x40000',
                        'dccm_bits' => 15,
                        'dccm_num_banks_8' => '',
                        'lsu_sb_bits' => 15,
                        'dccm_reserved' => '0x1000',
                        'dccm_fdata_width' => 39,
                        'dccm_index_bits' => 10,
                        'dccm_size' => 32,
                        'dccm_sadr' => '0xf0040000',
                        'dccm_num_banks' => '8'
                      },
            'verilator' => '',
            'reset_vec' => '0x80000000',
            'target' => 'default_pd',
            'regwidth' => '32',
            'pic' => {
                       'pic_meie_mask' => '0x1',
                       'pic_total_int_plus1' => 9,
                       'pic_meipt_count' => 8,
                       'pic_meigwctrl_count' => 8,
                       'pic_meip_count' => 4,
                       'pic_base_addr' => '0xf00c0000',
                       'pic_meipl_mask' => '0xf',
                       'pic_meie_offset' => '0x2000',
                       'pic_bits' => 15,
                       'pic_meigwctrl_offset' => '0x4000',
                       'pic_meipl_count' => 8,
                       'pic_region' => '0xf',
                       'pic_int_words' => 1,
                       'pic_mpiccfg_mask' => '0x1',
                       'pic_meigwclr_offset' => '0x5000',
                       'pic_meipt_mask' => '0x0',
                       'pic_meigwclr_count' => 8,
                       'pic_meipl_offset' => '0x0000',
                       'pic_total_int' => 8,
                       'pic_meip_offset' => '0x1000',
                       'pic_meip_mask' => '0x0',
                       'pic_meigwctrl_mask' => '0x3',
                       'pic_meie_count' => 8,
                       'pic_meigwclr_mask' => '0x0',
                       'pic_mpiccfg_offset' => '0x3000',
                       'pic_mpiccfg_count' => 1,
                       'pic_meipt_offset' => '0x3004',
                       'pic_offset' => '0xc0000',
                       'pic_size' => 32
                     },
            'iccm' => {
                        'iccm_region' => '0xe',
                        'iccm_bank_bits' => 3,
                        'iccm_eadr' => '0xee07ffff',
                        'iccm_size_512' => '',
                        'iccm_rows' => '16384',
                        'iccm_enable' => '0',
                        'iccm_data_cell' => 'ram_16384x39',
                        'iccm_sadr' => '0xee000000',
                        'iccm_num_banks' => '8',
                        'iccm_reserved' => '0x1000',
                        'iccm_size' => 512,
                        'iccm_index_bits' => 14,
                        'iccm_bits' => 19,
                        'iccm_num_banks_8' => '',
                        'iccm_offset' => '0xe000000'
                      }
          );
1;
