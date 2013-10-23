function [large_laplacian_channel] = large_laplacian(channels_data)
%This funcrtion takes a 1D array and calculates the large laplacian
%transformation
%The transformation is hard coded to the specific array of electrodes
%of the PMT brand provided by Mark on October 13th, 2013
%The transformation is only over the micro electrodes (65-124) and not the
%Macro (1-64)
%The electrodes are sperated in three clusters, two clutsers are the sets
%of microelectrodes 67-78, other is the set 111-122, and the last one is
%the set of remainign electrodes.

%The large laplacian can be expressed as a matrix.
%The clusters 1 and 2 will share the same transformation matrix and the
%last cluster will have a different value.
%transformation matris for cluster 1
elem_cluster_1 = 12;
elem_cluster_2 = 12;
elem_cluster_3 = 36;
trans_cluster_1 = zeros(elem_cluster_1)
trans_cluster_2 = zeros(elem_cluster_2);
trans_cluster_3 = zeros(elem_cluster_3);
cluster_1 = channels_data(3:14);
cluster_2 = channels_data(47:58);
cluster_3 = [channels_data(1:2) channels_data(15:46) channels_data(59:end)];

%hard coded large laplacian electrodes
[color_matrix,map,alpha]=imread('small_cluster.png')%This cluster is input manually
color_matrix=~im2bw(color_matrix);%we change ones to zeros and zeros to ones
trans_cluster_1 = color_matrix;
trans_cluster_2 = color_matrix;

end