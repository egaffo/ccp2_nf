include { writeMeta; runCCP2 } from './tasks.nf'

workflow {
  
  params.metafile   = "/sharedfs01/enrico/CLL/analysis/PRJNA432966/meta.csv"
  params.varsfile   = "/sharedfs01/enrico/CLL/analysis/PRJNA432966/vars.py"
  params.ccp2params = '-j2 -n'
  
  meta2split =  Channel
                .fromPath(params.metafile)
                .splitCsv(header: true, sep: ",", strip: true)
                .map { row -> tuple(row.sample, row.file, row.adapter) }
                .groupTuple( by: [0, 2] )
                
  writeMeta( meta2split )
  runCCP2( writeMeta.out.meta, params.varsfile, params.ccp2params )
}