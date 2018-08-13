require 'json'

module ASpaceIIIF
  class ViewBuilder
    def construct_mirador_object(file)
      f = File.read(file)
      JSON.parse(f)

      manifest_hash = parse_manifest_file(file)
      handle = manifest_hash["metadata"][0]["handle"]
      manifest_uri = manifest_hash["@id"]
      canvas_id = manifest_hash["sequences"][0]["canvases"][0]["@id"]
      label = manifest_hash["label"]

      @mirador_data = [
        {
          manifestUri: manifest_uri,
          location: "Boston College",
          title: label
        }
      ]
      @mirador_wobjects = [
        {
          canvasID: canvas_id,
          loadedManifest: manifest_uri,
          viewType: "ImageView"
        }
      ]
      @mirador_buttons = [
        {
          label: "View Library Record",
          iconClass: "fa fa-external-link",
          attributes: {
            class: "handle",
            href: handle,
            target: "_blank"
          }
        }
      ]
    end

    def build(file)
      construct_mirador_object(file)
      identifier = File.basename(file, File.extname(file))
      mdata = JSON.pretty_generate(@mirador_data)
      wobjects = JSON.pretty_generate(@mirador_wobjects)
      buttons = JSON.pretty_generate(@mirador_buttons)
      
      doc = <<-EOF
    <!DOCTYPE html>
    <html>

    <head>
      <!-- Global site tag (gtag.js) - Google Analytics -->
      <script async src="https://www.googletagmanager.com/gtag/js?id=UA-3008279-23"></script>
      <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());

        gtag('config', 'UA-3008279-23');
      </script>
      <title>#{identifier}</title>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <link rel="stylesheet" type="text/css" href="/iiif/build/mirador/css/mirador-combined.css"></link>
      <link rel="stylesheet" type="text/css" href="/iiif/bc-mirador/mirador-bc.css"></link>
      <link rel="stylesheet" type="text/css" href="/iiif/bc-mirador/slicknav.css"></link>
      <script type="text/javascript" src="/iiif/build/mirador/mirador.js"></script>
      <script type="text/javascript" src="/iiif/bc-mirador/jquery.slicknav.min.js"></script>
      <script type="text/javascript" src="/iiif/bc-mirador/downloadMenu.js"></script>
    </head>

    <body>
      <div id="viewer"></div>
      <script type="text/javascript">
        window.mdObj = {
          MIRADOR_DATA: #{mdata},
          MIRADOR_WOBJECTS: #{wobjects},
          MIRADOR_BUTTONS: #{buttons}
        };
      </script>
      <script type="text/javascript" src="/iiif/bc-mirador/bcViewer.js"></script>
    </body>

    </html>
      EOF

      puts doc
    end
  end
end