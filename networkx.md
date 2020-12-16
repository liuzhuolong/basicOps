## networkx
- networkx is a python package, which is used for creating graph(graph of 'graph theory')

## draw
- draw tree structure
  - firstly we should install graphviz
  - see `https://blog.csdn.net/ZVengin/article/details/102597216`
  ```shell
  yum install graphviz libgraphviz-dev graphviz-dev pkg-config
  pip install pygraphviz
  ```
  
- draw graph with parameters
  - see `https://blog.csdn.net/qq_41854763/article/details/103405760`
  ```python
  import networkx as nx
  import matplotlib.pyplot as plt

  G = nx.Graph()

  # write your topology construction logic here

  pos = nx.spring_layout(G) # choose a layout from https://networkx.github.io/documentation/latest/reference/drawing.html#module-networkx.drawing.layout
  nx.draw(G, pos)
  node_labels = {a dictionary contains what you want you show. Key:node_name. Value:text shown in node G.nodes[node_name]}
  nx.draw_networkx_labels(G, pos, labels=node_labels)
  edge_labels = {a dictionary contains what you want you show. Key:edge. Value:text shown in edge}
  nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels)
  plt.show()
  ```
